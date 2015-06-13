(function (console) { "use strict";
var List = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,__class__: List
};
Math.__name__ = ["Math"];
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null; else return js.Boot.getClass(o);
};
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
var haxe = {};
haxe.IMap = function() { };
haxe.IMap.__name__ = ["haxe","IMap"];
var belt = {};
belt.ClassMap = function() {
	this.h = new haxe.ds.StringMap();
};
belt.ClassMap.__name__ = ["belt","ClassMap"];
belt.ClassMap.__interfaces__ = [haxe.IMap];
belt.ClassMap.prototype = {
	set: function(k,v) {
		this.h.set(Type.getClassName(k),v);
	}
	,__class__: belt.ClassMap
};
var cosmos = {};
cosmos.ComponentProvider = function() { };
cosmos.ComponentProvider.__name__ = ["cosmos","ComponentProvider"];
cosmos.ComponentProvider.prototype = {
	__class__: cosmos.ComponentProvider
};
cosmos.CosmosPresenter = function() { };
cosmos.CosmosPresenter.__name__ = ["cosmos","CosmosPresenter"];
cosmos.CosmosPresenter.prototype = {
	__class__: cosmos.CosmosPresenter
};
var demo = {};
demo.comp = {};
demo.comp.type = {};
demo.comp.type.BioType = function(maxLife) {
	this.maxLife = 0;
	this.maxLife = maxLife;
};
demo.comp.type.BioType.__name__ = ["demo","comp","type","BioType"];
demo.comp.type.BioType.__interfaces__ = [cosmos.ComponentProvider];
demo.comp.type.BioType.prototype = {
	addComponents: function(components) {
		components.push(new demo.comp.Bio(this.maxLife));
	}
	,__class__: demo.comp.type.BioType
};
cosmos.provider = {};
cosmos.provider.InstanceComponentProvider1 = function() {
};
cosmos.provider.InstanceComponentProvider1.__name__ = ["cosmos","provider","InstanceComponentProvider1"];
cosmos.provider.InstanceComponentProvider1.__interfaces__ = [cosmos.ComponentProvider];
cosmos.provider.InstanceComponentProvider1.prototype = {
	addComponents: function(components) {
		components.push(new demo.comp.Placement(3,5));
	}
	,__class__: cosmos.provider.InstanceComponentProvider1
};
cosmos.GenericEntityType = function(id,components) {
	this.id = id;
	this._components = new belt.ClassMap();
	var _g = 0;
	while(_g < components.length) {
		var component = components[_g];
		++_g;
		var clazz = Type.getClass(component);
		if(!this._components.h.exists(Type.getClassName(clazz))) this._components.set(clazz,component);
	}
};
cosmos.GenericEntityType.__name__ = ["cosmos","GenericEntityType"];
cosmos.GenericEntityType.prototype = {
	get: function(componentClass) {
		return this._components.h.get(Type.getClassName(componentClass));
	}
	,has: function(componentClass) {
		return this._components.h.exists(Type.getClassName(componentClass));
	}
	,__class__: cosmos.GenericEntityType
};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [haxe.IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,iterator: function() {
		return new haxe.ds._StringMap.StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe.ds.StringMap
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js.Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js.Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js.Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js.Boot.__nativeClassName(o);
		if(name != null) return js.Boot.__resolveNativeClass(name);
		return null;
	}
};
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js.Boot.__string_rec(o[i1],s); else str2 += js.Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js.Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__nativeClassName = function(o) {
	var name = js.Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js.Boot.__isNativeObj = function(o) {
	return js.Boot.__nativeClassName(o) != null;
};
js.Boot.__resolveNativeClass = function(name) {
	if(typeof window != "undefined") return window[name]; else return global[name];
};
cosmos._EntityType = {};
cosmos._EntityType.EntityType_Impl_ = {};
cosmos._EntityType.EntityType_Impl_.__name__ = ["cosmos","_EntityType","EntityType_Impl_"];
cosmos._EntityType.EntityType_Impl_._new = function(type) {
	return type;
};
cosmos.GenericEntity = function(type,components) {
	this.type = type;
	this._components = new belt.ClassMap();
	var _g = 0;
	while(_g < components.length) {
		var component = components[_g];
		++_g;
		var clazz = Type.getClass(component);
		if(!this._components.h.exists(Type.getClassName(clazz))) this._components.set(clazz,component);
	}
};
cosmos.GenericEntity.__name__ = ["cosmos","GenericEntity"];
cosmos.GenericEntity.prototype = {
	get: function(componentClass) {
		return this._components.h.get(Type.getClassName(componentClass));
	}
	,has: function(componentClass) {
		return this._components.h.exists(Type.getClassName(componentClass));
	}
	,__class__: cosmos.GenericEntity
};
cosmos.Model = function(systems) {
	this.started = false;
	this._views = [];
	this._entities = new List();
	this._systems = new belt.ClassMap();
	this._updatableSystems = [];
	var _g = 0;
	while(_g < systems.length) {
		var system = systems[_g];
		++_g;
		if(system.updatable) this._updatableSystems.push(system);
		this._systems.set(system == null?null:js.Boot.getClass(system),system);
	}
	var _g1 = 0;
	while(_g1 < systems.length) {
		var system1 = systems[_g1];
		++_g1;
		var _g11 = 0;
		var _g2 = system1.views;
		while(_g11 < _g2.length) {
			var view = _g2[_g11];
			++_g11;
			this._views.push(view);
		}
	}
	var _g3 = 0;
	while(_g3 < systems.length) {
		var system2 = systems[_g3];
		++_g3;
		system2.model = this;
		system2._init();
	}
};
cosmos.Model.__name__ = ["cosmos","Model"];
cosmos.Model.prototype = {
	addPresenter: function(presenter) {
		presenter.model = this;
		var _g = 0;
		var _g1 = presenter.views;
		while(_g < _g1.length) {
			var view = _g1[_g];
			++_g;
			this._views.push(view);
			var _g2_head = this._entities.h;
			var _g2_val = null;
			while(_g2_head != null) {
				var entity;
				entity = (function($this) {
					var $r;
					_g2_val = _g2_head[0];
					_g2_head = _g2_head[1];
					$r = _g2_val;
					return $r;
				}(this));
				view.addEntityIfMatch(entity);
			}
		}
	}
	,start: function(now) {
		var $it0 = this._systems.h.iterator();
		while( $it0.hasNext() ) {
			var system = $it0.next();
			system.start(now);
		}
		this.started = true;
	}
	,update: function(now,delta) {
		if(!this.started) this.start(now); else {
			var _g = 0;
			var _g1 = this._updatableSystems;
			while(_g < _g1.length) {
				var system = _g1[_g];
				++_g;
				system.update(now,delta);
			}
		}
	}
	,addEntity: function(components) {
		var newEntity = new cosmos.GenericEntity(null,components);
		this._entities.add(newEntity);
		var _g = 0;
		var _g1 = this._views;
		while(_g < _g1.length) {
			var view = _g1[_g];
			++_g;
			view.addEntityIfMatch(newEntity);
		}
	}
	,addEntityOfType: function(entityType,components) {
		var type = entityType;
		var $it0 = type._components.h.iterator();
		while( $it0.hasNext() ) {
			var typeComponent = $it0.next();
			if(js.Boot.__instanceof(typeComponent,cosmos.ComponentProvider)) {
				var provider = typeComponent;
				provider.addComponents(components);
			}
		}
		var newEntity = new cosmos.GenericEntity(type,components);
		this._entities.add(newEntity);
		var _g = 0;
		var _g1 = this._views;
		while(_g < _g1.length) {
			var view = _g1[_g];
			++_g;
			view.addEntityIfMatch(newEntity);
		}
	}
	,removeEntity: function(entity) {
		this._entities.remove(entity);
		var _g = 0;
		var _g1 = this._views;
		while(_g < _g1.length) {
			var view = _g1[_g];
			++_g;
			view.removeEntity(entity);
		}
	}
	,__class__: cosmos.Model
};
cosmos.ModelFacet = function(componentClasses,typeComponentClasses) {
	this.list = new List();
	this.componentClasses = componentClasses.slice();
	this.typeComponentClasses = typeComponentClasses.slice();
};
cosmos.ModelFacet.__name__ = ["cosmos","ModelFacet"];
cosmos.ModelFacet.prototype = {
	onEntityAdded: function(func) {
		this.onAddedFunc = func;
	}
	,onEntityRemoved: function(func) {
		this.onRemovedFunc = func;
	}
	,addEntityIfMatch: function(entity) {
		var _g = 0;
		var _g1 = this.componentClasses;
		while(_g < _g1.length) {
			var componentClass = _g1[_g];
			++_g;
			if(!entity.has(componentClass)) return false;
		}
		var _g2 = 0;
		var _g11 = this.typeComponentClasses;
		while(_g2 < _g11.length) {
			var componentClass1 = _g11[_g2];
			++_g2;
			if(entity.type == null || !entity.type.has(componentClass1)) return false;
		}
		var theEntity = entity;
		this.list.add(theEntity);
		if(this.onAddedFunc != null) this.onAddedFunc(theEntity);
		return true;
	}
	,removeEntity: function(entity) {
		this.list.remove(entity);
		if(this.onRemovedFunc != null) this.onRemovedFunc(entity);
	}
	,__class__: cosmos.ModelFacet
};
cosmos.System = function() { };
cosmos.System.__name__ = ["cosmos","System"];
cosmos.System.prototype = {
	__class__: cosmos.System
};
demo.CosmosTest = function() { };
demo.CosmosTest.__name__ = ["demo","CosmosTest"];
demo.CosmosTest.main = function() {
	var model = new cosmos.Model([new demo.system.TestSystem(),new demo.system.Populator()]);
	model.start(0);
	model.update(0.02,0.02);
	model.addPresenter(new demo.system.Presenter());
};
demo.comp.Bio = function(life) {
	this.life = 0;
	this.life = life;
};
demo.comp.Bio.__name__ = ["demo","comp","Bio"];
demo.comp.Bio.prototype = {
	__class__: demo.comp.Bio
};
demo.comp.FlameComponent = function(value) {
	this.flame = value;
};
demo.comp.FlameComponent.__name__ = ["demo","comp","FlameComponent"];
demo.comp.FlameComponent.prototype = {
	__class__: demo.comp.FlameComponent
};
demo.comp.Placement = function(x,y) {
	this.x = x;
	this.y = y;
};
demo.comp.Placement.__name__ = ["demo","comp","Placement"];
demo.comp.Placement.prototype = {
	__class__: demo.comp.Placement
};
demo.comp.TestComponent = function(text) {
	this.value = text;
};
demo.comp.TestComponent.__name__ = ["demo","comp","TestComponent"];
demo.comp.TestComponent.prototype = {
	__class__: demo.comp.TestComponent
};
demo.system = {};
demo.system.Populator = function() {
	this.views = [];
	this.updatable = false;
};
demo.system.Populator.__name__ = ["demo","system","Populator"];
demo.system.Populator.__interfaces__ = [cosmos.System];
demo.system.Populator.prototype = {
	start: function(now) {
		haxe.Log.trace("Populator",{ fileName : "Populator.hx", lineNumber : 14, className : "demo.system.Populator", methodName : "start"});
		this.model.addEntity([new demo.comp.TestComponent("hello")]);
		this.model.addEntity([new demo.comp.TestComponent("hello2")]);
		this.model.addEntity([new demo.comp.FlameComponent(1)]);
		this.model.addEntity([new demo.comp.TestComponent("both"),new demo.comp.FlameComponent(2)]);
		this.model.addEntityOfType(cosmos._EntityType.EntityType_Impl_.DOG,[new demo.comp.TestComponent("DOG")]);
	}
	,_init: function() {
	}
	,update: function(now,delta) {
	}
	,__class__: demo.system.Populator
};
demo.system.Presenter = function() {
	this.views = [];
	this.set1 = new cosmos.ModelFacet([demo.comp.TestComponent],[]);
	this.views = [];
	this.views.push(this.set1);
};
demo.system.Presenter.__name__ = ["demo","system","Presenter"];
demo.system.Presenter.__interfaces__ = [cosmos.CosmosPresenter];
demo.system.Presenter.prototype = {
	__class__: demo.system.Presenter
};
demo.system.TestSystem = function() {
	this.views = [];
	this.updatable = true;
	this.set5 = new cosmos.ModelFacet([demo.comp.Placement],[]);
	this.set4 = new cosmos.ModelFacet([],[demo.comp.type.BioType]);
	this.set3 = new cosmos.ModelFacet([demo.comp.TestComponent,demo.comp.FlameComponent],[demo.comp.FlameComponent]);
	this.set2 = new cosmos.ModelFacet([demo.comp.FlameComponent],[]);
	this.set1 = new cosmos.ModelFacet([demo.comp.TestComponent],[]);
	this.views = [];
	this.views.push(this.set1);
	this.views.push(this.set2);
	this.views.push(this.set3);
	this.views.push(this.set4);
	this.views.push(this.set5);
};
demo.system.TestSystem.__name__ = ["demo","system","TestSystem"];
demo.system.TestSystem.__interfaces__ = [cosmos.System];
demo.system.TestSystem.prototype = {
	entityAddedToSet4: function(entity) {
		haxe.Log.trace("added : ",{ fileName : "TestSystem.hx", lineNumber : 24, className : "demo.system.TestSystem", methodName : "entityAddedToSet4", customParams : [entity]});
	}
	,entityRemovedFromSet4: function(entity) {
		haxe.Log.trace("removed : ",{ fileName : "TestSystem.hx", lineNumber : 28, className : "demo.system.TestSystem", methodName : "entityRemovedFromSet4", customParams : [entity]});
	}
	,update: function(now,dt) {
		haxe.Log.trace("set1",{ fileName : "TestSystem.hx", lineNumber : 32, className : "demo.system.TestSystem", methodName : "update"});
		var _g_head = this.set1.list.h;
		var _g_val = null;
		while(_g_head != null) {
			var entity;
			entity = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			haxe.Log.trace(entity.get(demo.comp.TestComponent).value,{ fileName : "TestSystem.hx", lineNumber : 34, className : "demo.system.TestSystem", methodName : "update"});
		}
		haxe.Log.trace("set2",{ fileName : "TestSystem.hx", lineNumber : 38, className : "demo.system.TestSystem", methodName : "update"});
		var _g_head1 = this.set2.list.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var entity1;
			entity1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			haxe.Log.trace(entity1.get(demo.comp.FlameComponent).flame,{ fileName : "TestSystem.hx", lineNumber : 40, className : "demo.system.TestSystem", methodName : "update"});
		}
		haxe.Log.trace("set3",{ fileName : "TestSystem.hx", lineNumber : 42, className : "demo.system.TestSystem", methodName : "update"});
		var _g_head2 = this.set3.list.h;
		var _g_val2 = null;
		while(_g_head2 != null) {
			var entity2;
			entity2 = (function($this) {
				var $r;
				_g_val2 = _g_head2[0];
				_g_head2 = _g_head2[1];
				$r = _g_val2;
				return $r;
			}(this));
			haxe.Log.trace(entity2.get(demo.comp.TestComponent).value + ", " + entity2.get(demo.comp.FlameComponent).flame,{ fileName : "TestSystem.hx", lineNumber : 44, className : "demo.system.TestSystem", methodName : "update"});
			haxe.Log.trace(entity2.type.get(demo.comp.FlameComponent).flame,{ fileName : "TestSystem.hx", lineNumber : 45, className : "demo.system.TestSystem", methodName : "update"});
		}
		haxe.Log.trace("set4",{ fileName : "TestSystem.hx", lineNumber : 47, className : "demo.system.TestSystem", methodName : "update"});
		var _g_head3 = this.set4.list.h;
		var _g_val3 = null;
		while(_g_head3 != null) {
			var entity3;
			entity3 = (function($this) {
				var $r;
				_g_val3 = _g_head3[0];
				_g_head3 = _g_head3[1];
				$r = _g_val3;
				return $r;
			}(this));
			haxe.Log.trace(entity3.type.get(demo.comp.type.BioType).maxLife,{ fileName : "TestSystem.hx", lineNumber : 49, className : "demo.system.TestSystem", methodName : "update"});
			haxe.Log.trace(entity3.type.id,{ fileName : "TestSystem.hx", lineNumber : 50, className : "demo.system.TestSystem", methodName : "update"});
			this.model.removeEntity(entity3);
		}
		haxe.Log.trace("set5",{ fileName : "TestSystem.hx", lineNumber : 53, className : "demo.system.TestSystem", methodName : "update"});
		var _g_head4 = this.set5.list.h;
		var _g_val4 = null;
		while(_g_head4 != null) {
			var entity4;
			entity4 = (function($this) {
				var $r;
				_g_val4 = _g_head4[0];
				_g_head4 = _g_head4[1];
				$r = _g_val4;
				return $r;
			}(this));
			haxe.Log.trace(entity4.get(demo.comp.Placement),{ fileName : "TestSystem.hx", lineNumber : 55, className : "demo.system.TestSystem", methodName : "update"});
		}
	}
	,_init: function() {
		this.set4.onEntityAdded($bind(this,this.entityAddedToSet4));
		this.set4.onEntityRemoved($bind(this,this.entityRemovedFromSet4));
	}
	,start: function(now) {
	}
	,__class__: demo.system.TestSystem
};
haxe.Log = function() { };
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
};
haxe.ds._StringMap = {};
haxe.ds._StringMap.StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
haxe.ds._StringMap.StringMapIterator.__name__ = ["haxe","ds","_StringMap","StringMapIterator"];
haxe.ds._StringMap.StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe.ds._StringMap.StringMapIterator
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.__name__ = ["Array"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
js.Boot.__toStr = {}.toString;
cosmos._EntityType.EntityType_Impl_.DOG = cosmos._EntityType.EntityType_Impl_._new(new cosmos.GenericEntityType("dog",[new demo.comp.type.BioType(3),new cosmos.provider.InstanceComponentProvider1()]));
demo.system.Populator.__meta__ = { fields : { _init : { '@:noCompletion' : null}, update : { '@:noCompletion' : null}, updatable : { '@:noCompletion' : null}, views : { '@:noCompletion' : null}}};
demo.system.Presenter.__meta__ = { fields : { views : { '@:noCompletion' : null}}};
demo.system.TestSystem.__meta__ = { fields : { update : { '@:noCompletion' : null}, _init : { '@:noCompletion' : null}, start : { '@:noCompletion' : null}, updatable : { '@:noCompletion' : null}, views : { '@:noCompletion' : null}}};
demo.CosmosTest.main();
})(typeof console != "undefined" ? console : {log:function(){}});

//# sourceMappingURL=Main.js.map