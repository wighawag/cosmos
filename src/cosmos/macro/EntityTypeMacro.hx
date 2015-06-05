package cosmos.macro;

import haxe.Json;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.io.File;
import haxe.DynamicAccess;

typedef TypeComponentDef = Dynamic;
typedef TypeDefinition = DynamicAccess<TypeComponentDef>;
typedef TypeDefinitions = DynamicAccess<TypeDefinition>;

class EntityTypeMacro
{

	public static function apply(jsonPath : String) : Array<Field>
	{
		var pos = Context.currentPos();
		var content = File.getContent(jsonPath);
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
				var jsonString = Json.stringify(typeDefinitions[typeName][componentClassPath]);
				var json = macro haxe.Json.parse($v { jsonString } );
				components.push( { expr:ENew(typePath, [json]), pos:pos } );
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