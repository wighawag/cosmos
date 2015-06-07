package cosmos.macro;
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ExprTools;

class ProviderMacro
{
	static var counter = 0;
	public static function createProvider(componentConstructions : Array<Expr>) : TypePath
	{
		var pos = Context.currentPos();
		counter++;
		var typePath = { name:"InstanceComponentProvider" + counter, pack:["cosmos", "provider"] } 
		
		var fields = new Array<Field>();
		fields.push( {
			pos:pos,
			name:"new",
			kind:FFun({ret:null,expr:macro {},args:[]}),
			access:[APublic]
		});
		
		for ( i in 0...componentConstructions.length) {
			componentConstructions[i] = macro components.push($e { componentConstructions[i] } );
		}
		var block = macro $b { componentConstructions };
		
		fields.push( {
			pos:pos,
			name:"addComponents",
		kind:FFun({ret:null,expr:block,args:[{name:"components",type:macro :Array<Dynamic>}]}),
			access:[APublic]
		});
		
		var typeDefinition = {
			pos:pos,
			pack:typePath.pack,
			name:typePath.name,
			kind:TDClass(null,[{pack:["cosmos"],name:"ComponentProvider"}],false),
			fields:fields
			};
		
		Context.defineType(typeDefinition);
		
		return typePath;
	}
	
}