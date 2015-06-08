package cosmos.macro;

import haxe.Json;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.io.File;
import haxe.DynamicAccess;

typedef TypeComponentDef = DynamicAccess<Dynamic>;
typedef InstanceComponentDef = DynamicAccess<Dynamic>;
typedef TypeDefinition = {type:DynamicAccess<TypeComponentDef>, instance:DynamicAccess<InstanceComponentDef>};
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
			var typeDefinition = typeDefinitions[typeName];
			var components : Array<Expr> = [];
			for (componentClassPath in typeDefinition.type.keys()) {
				var componentDef = typeDefinition.type[componentClassPath];
				var dotIndex = componentClassPath.lastIndexOf(".");
				var typePath = { name : "", pack:[] };
				if (dotIndex == -1) {
					typePath.name = componentClassPath;
				}else {
					typePath.name = componentClassPath.substr(dotIndex + 1);
					typePath.pack = componentClassPath.substring(0, dotIndex).split(".");
				}

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
									if (componentDef.exists(arg.name)) {
										argExprs.push(macro $v { componentDef[arg.name] } );
										componentDef.remove(arg.name);
									}else {
										Context.error("Missing argument for " + componentClassPath + " : " + arg.name, pos);
									}
								}
								for (extraArgName in componentDef.keys()) {
									Context.warning("Extra argument for " + componentClassPath + " : " + extraArgName, pos);
								}
							default:Context.error("constructor should be a TFun", pos);
						}
					default: Context.error("can only be a class", pos);
				}
				
				components.push( { expr:ENew(typePath, argExprs), pos:pos } );
			}
			
			
			
			var instanceComponentConstructions = new Array<Expr>();
			for (componentClassPath in typeDefinition.instance.keys()) {
				var componentDef = typeDefinition.instance[componentClassPath];
				var dotIndex = componentClassPath.lastIndexOf(".");
				var typePath = { name : "", pack:[] };
				if (dotIndex == -1) {
					typePath.name = componentClassPath;
				}else {
					typePath.name = componentClassPath.substr(dotIndex + 1);
					typePath.pack = componentClassPath.substring(0, dotIndex).split(".");
				}

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
									if (componentDef.exists(arg.name)) {
										argExprs.push(macro $v { componentDef[arg.name] } );
										componentDef.remove(arg.name);
									}else {
										Context.error("Missing argument for " + componentClassPath + " : " + arg.name, pos);
									}
								}
								for (extraArgName in componentDef.keys()) {
									Context.warning("Extra argument for " + componentClassPath + " : " + extraArgName, pos);
								}
							default:Context.error("constructor should be a TFun", pos);
						}
					default: Context.error("can only be a class", pos);
				}
				
				instanceComponentConstructions.push({ expr:ENew(typePath, argExprs), pos:pos } );
			}
			
			if (instanceComponentConstructions.length > 0) {
				var typePath = ProviderMacro.createProvider(instanceComponentConstructions);
				components.push( { expr:ENew(typePath, []), pos:pos } );
			}
			
			fields.push( {
				pos:pos,
				name:typeName.toUpperCase(),
				kind:FProp("default","null",macro:cosmos.EntityType,macro new cosmos.EntityType(new cosmos.GenericEntityType($v{typeName},$e{{expr:EArrayDecl(components),pos:pos}}))),
				access:[AStatic, APublic]
			} );
		}

		return fields;
	}
	
}