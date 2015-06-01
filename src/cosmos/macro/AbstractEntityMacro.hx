package cosmos.macro;
import haxe.macro.Expr;
import haxe.macro.Context;
class AbstractEntityMacro{
    macro static public function apply() : ComplexType{
		return TPath({name:"GenericEntity", pack:["cosmos"]});
	}
}