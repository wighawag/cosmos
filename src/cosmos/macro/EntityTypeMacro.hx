package cosmos.macro;

import haxe.Json;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.io.File;
import haxe.DynamicAccess;

typedef TypeComponentDef = DynamicAccess<Dynamic>;
typedef TypeDefinition = DynamicAccess<TypeComponentDef>;
typedef TypeDefinitions = DynamicAccess<TypeDefinition>;

class EntityTypeMacro
{

	public static function apply() : Array<Field>
	{
		//TODO get types.json form compiler, if not found do not use types
		var jsonPath : String = "types.json";
		
		var pos = Context.currentPos();
		var content : String = "";
		try {
			content = File.getContent(jsonPath);
		}catch( e : Dynamic){
			return null;
		}
		
		var typeDefinitions : TypeDefinitions = Json.parse(content);
		var fields = Context.getBuildFields();
		for (typeName in typeDefinitions.keys()) {
			var components : Array<Expr> = [];
			for (componentClassPath in typeDefinitions[typeName].keys()) {
				var dotIndex = componentClassPath.lastIndexOf(".");
				var typePath = { name : "", pack:[] };
				if (dotIndex == -1) {
					typePath.name = componentClassPath;
				}else {
					typePath.name = componentClassPath.substr(dotIndex + 1);
					typePath.pack = componentClassPath.substring(0, dotIndex).split(".");
				}
				//var jsonString = Json.stringify(typeDefinitions[typeName][componentClassPath]);
				//var json = macro haxe.Json.parse($v { jsonString } );
				//
				var type = Context.getType(componentClassPath);
				var argExprs : Array<Expr> = [];
				switch(type) {
					case TInst(ref, _):
						var field = ref.get().constructor.get();
						var type = switch(field.type) {
							case TLazy(f):
								f();
							default:field.type;
						}
						switch(type) {
							case TFun(args, _):
								for (arg in args) {
									argExprs.push(macro $v { typeDefinitions[typeName][componentClassPath][arg.name] } );
								}
							default:Context.error("constructor should be a TFun", pos);
						}
					default: Context.error("can only be a class", pos);
				}
				
				components.push( { expr:ENew(typePath, argExprs), pos:pos } );
			}
			fields.push( {
				pos:pos,
				name:typeName.toUpperCase(),
				kind:FProp("default","null",macro:cosmos.EntityType,macro new cosmos.EntityType(new cosmos.GenericEntity(null,$e{{expr:EArrayDecl(components),pos:pos}}))),
				access:[AStatic, APublic]
			} );
		}

		return fields;
	}
	
}