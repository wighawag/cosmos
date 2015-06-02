package cosmos.macro;
import haxe.macro.Expr;
import haxe.macro.Context;

class SystemMacro{
	public static function apply() : Array<Field>{
		var pos = Context.currentPos();
		var newFields = new Array<Field>();
		var fields = Context.getBuildFields();
		var hasInitialiseField = false;
		var viewNames : Array<String> = new Array();
		for (field in fields){
			if(field.name == "initialise"){
				hasInitialiseField = true;
			}
			switch(field.kind){
				case FVar(type,expr):
					switch(type){
						case TPath(typePath):
							if(typePath.name == "List" && typePath.params.length == 1){
								switch(typePath.params[0]){
									case TPType(TPath(p)):
										if(p.name == "Entity"){
											viewNames.push(field.name);
											var newField = {
												pos:field.pos,
												name:field.name,
												meta:field.meta,
												kind : FVar(type,macro new $typePath()), //required , I do not know why?
												doc:field.doc,
												access:field.access
												};
											newFields.push(newField);	
											//newFields.push(field);
										}else{
											newFields.push(field);
										}
										
									default:newFields.push(field);
								}
							}else if(typePath.name == "Entities" && typePath.params.length == 1){
								viewNames.push(field.name);
								var newField = {
									pos:field.pos,
									name:field.name,
									meta:field.meta,
									kind : FVar(type,macro new $typePath()), //required , I do not know why?
									doc:field.doc,
									access:field.access
									};
								newFields.push(newField);	
								//newFields.push(field);
							}else{
								newFields.push(field);
							}
						default:newFields.push(field);
					}
				default:newFields.push(field);
			}
		}

		if(!hasInitialiseField){
			newFields.push({
                name:"initialise", 
                access:[APublic],
                kind : FFun({
                    args:[], 
                    ret:null, 
                    expr:macro {}
                }), 
                pos : pos
            });
		}

		newFields.push({
                name:"views", 
                access:[APublic], //TODO private with @:allow Model
                kind : FVar(macro :Array<List<cosmos.GenericEntity>>,macro new Array()), 
                pos : pos
            });


		if(viewNames.length > 0){
			var constructorExprs : Array<Expr>;
		    // get the fields of the current class
		    for (field in newFields){
		        if (field.name == "new"){
		            switch(field.kind){
		                case FieldType.FFun( func ):
		                    switch (func.expr.expr){
		                        case EBlock(exprs): constructorExprs = exprs;
		                        default : Context.error("No Constructor is not a block", pos);
		                    }

		                default : Context.error("constructor should be a function",pos);
		            }
		        }
		    }

		    if (constructorExprs == null){
		    	constructorExprs = new Array<Expr>();
		    	newFields.push({
		    		name:"new", 
	                access:[APublic],
	                kind : FFun({
                        args:[], 
                        ret:null, 
                        expr:{expr:EBlock(constructorExprs), pos:pos}
                    }),
	                pos : pos
		    		});
		    }

		    constructorExprs.push(macro views = new Array());
	    	for (viewName in viewNames){
	    		constructorExprs.push(macro views.push(cast $i{viewName}));
			}

		}
		

		newFields.push({
                name:"model", 
                access:[APublic], //TODO private with @:allow Model
                kind : FVar(TPath({name:"Model",pack:["cosmos"]}),null), 
                pos : pos
            });

		return newFields;
	}
}