package cosmos.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
using haxe.macro.Tools;

class EntitiesMacro{

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
            return types[classPath.name];
        }

        var newFields : Array<Field> = [];
        newFields.push({
                name: "test",
                pos: pos,
                access: [APublic],
                kind: FVar(macro : Int,macro 0), //TODO -1 or 0 ? 
                });
		
        var typeDefinition : TypeDefinition = {
            pos : pos,
            pack : classPath.pack,
            name : classPath.name,
            kind :TDClass({pack :[], name: "List", params:[TPType(TPath({pack:["cosmos"],name:"Entity"}))]},[], false),
            fields:newFields
        }
        Context.defineType(typeDefinition);

        // macro @:pos(field.expr.pos) var x = 0;

        var type = TPath(classPath);
        types[classPath.name] = type;
		return type;
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
            var newTypeName = "EntityList_" + numTypes;
            typeNames[typeName] = newTypeName;
            typeName = newTypeName;
        }
        


		return {pack:["cosmos","entity"], name:typeName};
	}
}