package cosmos.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
using haxe.macro.Tools;
import haxe.macro.ComplexTypeTools;

class AbstractEntityMacro{

    static var types : Map<String,ComplexType> = new Map();
    static var typeNames : Map<String,String> = new Map();
    static var numTypes = 0;

    macro static public function apply() : Type{
        var pos = Context.currentPos();

        var localType = Context.getLocalType();
		
		var fields = AbstractEntityMacro.getFieldsFromAnonymousTypeParam(localType);
        
        if(fields == null){
            Context.error("type not supported " + localType, pos);
            return null;
        }

        return ComplexTypeTools.toType(getOrCreateAbstractEntity(fields));
    }

    public static function getOrCreateAbstractEntity(fields, ?isType : Bool = false){
        var classPath = getClassPathFromClassFields(fields, isType);

        var type : ComplexType = null;
		var name = classPath.name;
		
        if(classPath != null && types.exists(name)){
            type = types[name];
        }else{
            type = createAbstractEntityFromFields(classPath, fields, isType);  
            types[name] = type; 
        }

        return type;
    }

    private static function createAbstractEntityFromFields(classPath, fields : Array<ClassField>, ?isType : Bool = false){
        var useFieldName : Bool = true;
        var pos = Context.currentPos();
        
		var newFields = new Array<Field>();
        var genericEntityType = TPath( { name:"GenericEntity", pack:["cosmos"] } );
		if (isType) {
			genericEntityType = TPath( { name:"GenericEntityType", pack:["cosmos"] } );	
			newFields.push({
					name:"get_id", 
					access:[APublic,AInline],
					kind : FFun({
						args:[], 
						ret:macro:String, 
						expr:macro return this.id
					}), 
					pos : pos
				});
			newFields.push({
					name:"id", 
					access:[APublic],
					kind : FProp("get", "never",macro:String,null), 
					pos : pos
				});
		}
       
        for (field in fields) {
			if (!isType && field.name == "type") {
				switch(field.type) {
				case TAnonymous(t):
					var typePath = getOrCreateAbstractEntity(t.get().fields,true);
					newFields.push({
                            name:"get_" + field.name, 
                            access:[APublic,AInline],
                            kind : FFun({
                                args:[], 
                                ret:typePath, 
                                expr:macro return cast this.type
                            }), 
                            pos : pos
                        });
					newFields.push({
                            name:field.name, 
                            access:[APublic],
                            kind : FProp("get", "never",typePath,null), 
                            pos : pos
                        });
				default: Context.error("type not supported " + field.type, pos);
				}

			}else {
				switch(field.type){
                case TInst(classType, params): 
                    var className = classType.get().name;
                    var classPackage = classType.get().pack;
                    var eField = createAnEField(className, classPackage);
                    if(useFieldName){
                        newFields.push({
                            name:"get_" + field.name, 
                            access:[APublic,AInline],
                            kind : FFun({
                                args:[], 
                                ret:TPath({name:className, pack:classPackage}), 
                                expr:macro return this.get($e{eField})
                            }), 
                            pos : pos
                        });
                        newFields.push({
                            name:field.name, 
                            access:[APublic],
                            kind : FProp("get", "never",TPath({name:className, pack:classPackage}),null), 
                            pos : pos
                        });
                    }else{
                        newFields.push({
                            name:"get" + className, 
                            access:[APublic,AInline],
                            kind : FFun({
                                args:[], 
                                ret:TPath({name:className, pack:classPackage}), 
                                expr:macro return this.get($e{eField})
                            }), 
                            pos : pos
                        });
                    }
                    
                default : Context.error("do not support " + field.type + " as component", pos);
				}
			}
            
        }
        var typeDefinition : TypeDefinition = {
            pos : pos,
            pack : classPath.pack,
            name : classPath.name,
            kind :TDAbstract(genericEntityType, null,[genericEntityType]),
            fields:newFields
        }

        Context.defineType(typeDefinition);

        var type : ComplexType = TPath(classPath);

        return type;
    }

    public static function createAnEField(className : String, classPackage : Array<String>) : Expr{
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

    public static function getFieldsFromAnonymousTypeParam(type : Type){
        var pos = Context.currentPos();
        var typeParam = switch (type) {
            case TInst(_,[tp]):
                switch(tp){
                    case TType(t,param): t.get().type;//TODO check
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

    private static function getClassPathFromClassFields(fields : Array<haxe.macro.ClassField>, isType : Bool) :  TypePath{
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
		
		if (isType) {
			typeName += "Type";
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