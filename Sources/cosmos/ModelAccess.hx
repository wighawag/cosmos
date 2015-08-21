package cosmos;

import haxe.macro.Expr;
import haxe.macro.Context;

class ModelAccess
{
	
	//TODO
	macro public static function addEntityWithComponents(model : ExprOf<cosmos.ModelData>, expr : Expr) {
		trace(expr);
		var pos = Context.currentPos();
		switch(expr.expr) {
			case EObjectDecl(fields):
				var componentClass;
				for (field in fields) {
					trace(field);
					if (field.field == "component") {
						switch(field.expr.expr) {
							case EConst(CIdent(s)):
								trace(Context.getType(s));
							default: Context.error("component need to be a class", pos); //TODO full pack Path
						}
					}
				}
			default: Context.error("need to be an anonymous object", pos);
		}
		return expr;
	}
	
	//public static function createATypePath(className : String, classPackage : Array<String>) : Expr{
        //if(classPackage.length == 0){
            //return macro $i{className};
        //}
        //var expr = macro $i{classPackage[0]};
        //var i = 1;
        //while(i < classPackage.length){
            //expr = {expr : EField(expr,classPackage[i]), pos : Context.currentPos()};
            //i++;
        //}
        //expr = {expr : EField(expr,className), pos : Context.currentPos()};
        //return expr;
    //}
	
}