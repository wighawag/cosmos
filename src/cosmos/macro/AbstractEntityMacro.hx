package cosmos.macro;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
using haxe.macro.Tools;

class AbstractEntityMacro{

    static var types : Map<String,ComplexType> = new Map();
    static var typeNames : Map<String,String> = new Map();
    static var numTypes = 0;

    macro static public function apply() : ComplexType{
        var pos = Context.currentPos();

        var localType = Context.getLocalType();

        var fields = getFieldsFromAnonymousTypeParam(localType);
        
        if(fields == null){
            Context.error("type not supported " + localType, pos);
            return null;
        }
        

        var classPath = getClassPathFromClassFields(fields);

        if(classPath != null && types.exists(classPath.name)){
            trace("already built");
            return types[classPath.name];
        }

        var genericEntityType = TPath({name:"GenericEntity", pack:["cosmos"]});
        var newFields = new Array<Field>();
        for(field in fields){
            switch(field.type){
                case TInst(classType, params): 
                    var className = classType.get().name;
                    var classPackage = classType.get().pack;
                    var eField = createAnEField(className, classPackage);
                    newFields.push({
                        name:"get" + className, 
                        access:[APublic],
                        kind : FFun({
                            args:[], 
                            ret:TPath({name:className, pack:classPackage}), 
                            expr:macro return this.get($e{eField})
                        }), 
                        pos : pos
                    });
                default : Context.error("do not support " + field.type + " as component", pos);
            }
        }
        var typeDefinition : TypeDefinition = {
            pos : pos,
            pack : classPath.pack,
            name : classPath.name,
            kind :TDAbstract(genericEntityType),
            fields:newFields
        }

        Context.defineType(typeDefinition);

        var type = TPath(classPath);

        types[classPath.name] = type;
        return type;
    }

    private static function createAnEField(className : String, classPackage : Array<String>) : Expr{
        if(classPackage.length == 0){
            return macro $i{className};
        }
        var expr = macro $i{classPackage[0]};
        var i = 1;
        while(i < classPackage.length){
            expr = {expr : EField(expr,classPackage[i]), pos : Context.currentPos()};
            i++;
        }
        expr = {expr : EField(expr,className), pos : Context.currentPos()};
        return expr;
    }

    private static function getFieldsFromAnonymousTypeParam(type : Type){
        var pos = Context.currentPos();
        var typeParam = switch (type) {
            case TInst(_,[tp]):
                switch(tp){
                    case TType(t,param): t.get().type;
                    case TAnonymous(t) : tp;
                    default : null;
                }
            default:null;
        }
        
        
        if(typeParam == null){
            //TODO error
            return null;
        }

        return switch(typeParam){
            case TInst(ref,_):
                 ref.get().fields.get();
            case TMono(mono):  Context.error("need to specify the program type explicitely, no type inference : " + typeParam + " (" + mono.get() + ")",pos); null; 
            case TAnonymous(ref):
                ref.get().fields;
            default: null;
        };

    }

    private static function getClassPathFromClassFields(fields : Array<haxe.macro.ClassField>) :  TypePath{
        fields = fields.copy();
        fields.sort(function(x,y){
            if(x.name == y.name){
                return 0;
            }
            return x.name < y.name ? -1 : 1;
            });

        var typeName = "";
        for (field in fields){
            typeName += field.type.toString();
        }

        if (typeNames.exists(typeName)){
            //trace("already generated " + bufferClassPath.name);
            typeName = typeNames[typeName];
        }else{
            //TODO use different naming
            numTypes++;
            var newTypeName = "AbstractEntity_" + numTypes;
            typeNames[typeName] = newTypeName;
            typeName = newTypeName;
        }
        

        return {pack:["cosmos","entity"], name:typeName};
    }

}