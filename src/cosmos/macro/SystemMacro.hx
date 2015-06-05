package cosmos.macro;
import haxe.macro.Expr;
import haxe.macro.Context;

class SystemMacro{
	public static function apply() : Array<Field> {
	
		var localClass = Context.getLocalClass().get();
        if (localClass.isInterface){
            return null;
        }
		
		var pos = Context.currentPos();
		var newFields = new Array<Field>();
		
		var fields = Context.getBuildFields();
		var hasInitialiseField = false;
		var hasUpdateField = false;
		var viewNames : Array<String> = new Array();
		for (field in fields){
			if(field.name == "initialise"){
				hasInitialiseField = true;
				newFields.push(field);
				continue;
			}
			if (field.name == "update") {
				hasUpdateField = true;
				field.meta.push( { pos:pos, name:"@:noCompletion" } ); //TODO test
				newFields.push(field);
				continue;
			}
			switch(field.kind){
				case FVar(type,expr):
					switch(type){
						case TPath(typePath):
							if(typePath.name == "Entities" && typePath.params.length == 1){
								var componentTypePaths = new Array<Expr>();
								var typeComponentTypePaths = new Array<Expr>();
								switch(typePath.params[0]){
									case TPType(TAnonymous(componentFields)):
										for (componentField in componentFields) {
											if (componentField.name == "type") {
												switch(componentField.kind){
												case FVar(t,_):
													switch(t){
														case TAnonymous(typeComponentFields):
															for (typeComponentField in typeComponentFields) {																
																switch(typeComponentField.kind){
																case FVar(t,_):
																	switch(t){
																		case TPath(p):
																			typeComponentTypePaths.push(AbstractEntityMacro.createAnEField(p.name, p.pack));
																		default: Context.error("component spec not valid " + typePath.params[0],pos);
																	}
																default: Context.error("component spec not valid " + typePath.params[0],pos);
																}
															}
														default: Context.error("component spec not valid " + typePath.params[0],pos);
													}
												default: Context.error("component spec not valid " + typePath.params[0],pos);
												}
											}else {
												switch(componentField.kind){
												case FVar(t,_):
													switch(t){
														case TPath(p):
															componentTypePaths.push(AbstractEntityMacro.createAnEField(p.name, p.pack));
														default: Context.error("component spec not valid " + typePath.params[0],pos);
													}
												default: Context.error("component spec not valid " + typePath.params[0],pos);
												}
											}
											
										}
									default:Context.error("component spec not valid " + typePath.params[0],pos);
								}
								viewNames.push(field.name);
								var newField = {
									pos:field.pos,
									name:field.name,
									meta:field.meta,
									kind : FVar(type,macro new $typePath($e{{expr:EArrayDecl(componentTypePaths),pos:pos}},$e{{expr:EArrayDecl(typeComponentTypePaths),pos:pos}})), 
									doc:field.doc,
									access:field.access
									};
								newFields.push(newField);	
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
                access:[APrivate],
                kind : FFun({
                    args:[], 
                    ret:null, 
                    expr:macro {}
                }), 
				meta : [{pos:pos,name:"@:noCompletion"}], //TODO test
                pos : pos
            });
		}
		
		if (!hasUpdateField) {
			newFields.push({
                name:"update", 
                access:[APrivate],
                kind : FFun({
					args:[{name:"now",type:macro :Float},{name:"delta",type:macro :Float}], 
                    ret:null, 
                    expr:macro {}
                }), 
				meta : [{pos:pos,name:"@:noCompletion"}], //TODO test
                pos : pos
            });
		}
		
		newFields.push({
                name:"updatable", 
                access:[APrivate], //TODO private with @:allow Model
                kind : FVar(macro :Bool, macro $v{hasUpdateField}), 
				meta : [{pos:pos,name:"@:noCompletion"}],//TODO test
                pos : pos
            });


		newFields.push({
                name:"views", 
                access:[APrivate], //TODO private with @:allow Model
                kind : FVar(macro :Array<cosmos.ModelFacet<cosmos.GenericEntity>>, macro new Array()), 
				meta : [{pos:pos,name:"@:noCompletion"}],//TODO test
                pos : pos
            });


		var constructorExprs : Array<Expr> = null;
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

		if(viewNames.length > 0){
		    constructorExprs.push(macro views = new Array());
	    	for (viewName in viewNames){
	    		constructorExprs.push(macro views.push(cast $i{viewName}));
			}

		}
		

		newFields.push({
                name:"model", 
                access:[APublic], //TODO private with @:allow Model
                kind : FVar(TPath({name:"ModelData",pack:["cosmos"]}),null), 
                pos : pos
            });

		return newFields;
	}
}