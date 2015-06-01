package cosmos.macro;
import haxe.macro.Expr;
import haxe.macro.Context;

class SystemMacro{
	public static function apply() : Array<Field>{
		var pos = Context.currentPos();
		var newFields = new Array<Field>();
		var fields = Context.getBuildFields();
		for (field in fields){
			switch(field.kind){
				case FVar(type,expr):
					switch(type){
						case TPath(typePath):
							if(typePath.name == "Entities"){
								var newField = {
									pos:field.pos,
									name:field.name,
									meta:field.meta,
									kind : FVar(type,macro new $typePath()), //required , I do not know why?
									doc:field.doc,
									access:field.access
									};
								newFields.push(newField);
							}
						default:newFields.push(field);
					}
				default:newFields.push(field);
			}
		}

		return newFields;
	}
}