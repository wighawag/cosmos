package cosmos.macro;

import cosmos.macro.AbstractEntityMacro;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
using haxe.macro.Tools;
import haxe.macro.ComplexTypeTools;

class EntitiesMacro{

	static var types : Map<String,ComplexType> = new Map();
	static var typeNames : Map<String,String> = new Map();
    static var numTypes = 0;

	public static function apply(){
		var useFieldName = true;
        var pos = Context.currentPos();
        var localType = Context.getLocalType();

        var fields = AbstractEntityMacro.getFieldsFromAnonymousTypeParam(localType);
        
        if(fields == null){
            Context.error("type not supported " + localType, pos);
            return null;
        }

        var classPath = getClassPathFromClassFields(fields);

        var entityType : ComplexType = AbstractEntityMacro.getOrCreateAbstractEntity(fields);

        return TPath({pack:["cosmos"],name:"ModelFacet", params:[TPType(entityType)]});
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
            var newTypeName = "Entities_" + numTypes;
            typeNames[typeName] = newTypeName;
            typeName = newTypeName;
        }
        

        return {pack:["cosmos","entity"], name:typeName};
    }
}