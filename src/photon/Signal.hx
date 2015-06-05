package photon;

class Signal<T>
{
	var funcs : Array<T->Void>;
	public function new() 
	{
		funcs = new Array();
	}
	
	public function whenever(func : Type-> Void) {
		funcs.push(func);
	}
	
	public function cancel(func
	
}