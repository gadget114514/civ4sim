class S {
 static log(s) {
	System.printAll(s)
 }
}
S.log("a")


var C_RESOURCE=20
var C_TECH=21
var C_BUILDING=22
var C_POP=30
var C_POWER=31
var C_CONDITEM=32
var C_ITEM=33
var C_EXPRITEM=34




var C_JOB_UE=17
var C_JOB_TOWN=18
var C_JOB_FARM=19
var C_JOB_MINE=20

var C_VILLEAGE=40
var C_TOWN=41
var C_CITY=42
var C_POLISE=43
var C_MEGAPOLICE=44
var C_COUNTRY=45
var C_EMPIRE=46

var C_PREREQ=48
var C_PREPAY=49
var C_POSTPAY=50

var C_TECH_MIN=TV C_TECH_ADVANCEDFLIGHT
var C_TECH_MAX=TV C_TECH_WRITING
var C_BUILDING_MIN=BV C_BUILDING_AIRPORT
var C_BUILDING_MAX=BV C_BUILDING_ZIGGURAT

class Effect {
      construct new(etype, op, count) {
      		_etype =		etype
		_op = op
		_count = count
      }
      etype{_etype}      
      op{_op}
      count{_count}      
}



class ConditionManager {
	construct new() {
		_conditions = {}
		_prereq= {}
		_prepay= {}
		_postpay= {}
		_conditionname = {}
		_conditiontitle = {}
		_kinds={}
	}
	conditions  { _conditions }
	prereq {_prereq}
	prepay { _prepay}
	postpay {_postpay}
	kinds {_kinds}	
	conditionname {_conditionname }
	conditiontitle {_conditiontitle}
}

class Base {
	construct new(type) {
		_ctype = type		  
        }
	ctype { _ctype }
	ctype=(v) { 
		_ctype = v 
	}
}

class CondItem is Base {
	construct new(st, count) {
	        super(C_CONDITEM)
		_subtype = st
		_count = count
	}
	ctype {_ctype}
	subtype { 
		return _subtype 
	}
}


class Condition is Base {
	construct new(name, type, kind) {
		  super(type)		  
//		System.print("Condition#new " + name)
		_name = name
		_ctype = type
		_subtype = kind
		_prereq= []
		_postpay= []
		_prepay= []
		_followers= []
		_effects= {}
		_effectdata=[]
		_bonus=[]
		_title=""
	}
	followers {
		return _followers
	}	
	add_prereq(v) {
		_prereq.add(v)
	}
	add_postpay(v) {
		_postpay.add(v)
	}
	add_prepay(v) {
		_prepay.add(v)
	}
	prereq=(v) {
		_prereq = v
	}
	prereq {
		return _prereq
	}
	postpay {
		return _postpay
	}
	prepay {
		return _prepay
	}
	follows(x) { 
		this.prereq.add(x)  
		x.followers.add(this)
	}
	followedby(x) { 
//		System.print(x)
//		System.print(x.prereq)
//		System.print(this.prereq)
		x.prereq.add(this)
		this.followers.add(x)
	}
	addeffect(v) {
	     for (k in v.keys) {
		_effects[k] = v[k]
	     }
	}
	effects{_effects}
	name {_name}
	name=(v) {	
		_name=v
	}
	subtype {_subtype}
	subtype=(v) {	
		_subtype=v
	}
	title { _title}
	title=(v) { 
		_title = v 
	}
	bonus{_bonus}
	bonus=(v) {
		  _bonus = v
        }
	effectdata{_effectdata}
	effectdata=(v) {
		  _effectdata = v
        }
}

class Item is Base {
	construct new(city, cv, st, count) {
	        super(C_ITEM)
		_subtype = st
		_count = count
		_city = city
		_cv = cv
		_money = 0
		_beaker= 0
		_gear = 0
		_art = 0
		_symbol = 0
		_req = []
	}
	ctype { 
		return _ctype 
	}
	ctype=(v) { _ctype = v }
	subtype { 
		return _subtype 
	}
	subtype=(v) { _subtype = v }
	count { _count }
	count=(v) { _count = v }
	owned { _owned }
	owned=(v) { _owned = v }
	gear{ _gear}
	gear=(v) { _gear= v }
	money{ _money}
	money=(v) { _money= v }
	req{ _req}
	req=(v) { _req= v }
	city { _city }

	fire(event) {
		    //
		    //
		    System.printAll([{"item#fire": event}])
		      var cond = city.cv.cm.conditions[this.subtype]
     		      var effectproc = cond.effects[event]
		      if (effectproc) {
		      		      effectproc.call(this)
		      } else {
		      	System.printAll(["not found event ", event])
		      }
	}
	display() {
		  System.print("ITEM")
		  System.print([_subtype, city.cv.cm.conditionname[_subtype], _count])		  
	}
	toString() {
		   var s = [_subtype, " ", city.cv.cm.conditionname[_subtype], " ", _count].join()
		   return s
	}
}

var CITY_MUST_HAVE=1
var CMH=1

class CResource is Condition {
	construct new(st, count, misc) {
		  super("", C_RESOURCE, st)
		_count = count
		_misc = misc
	}
	subtype{_subtype}
	count{_count}
	misc{_misc}
}




class CTech is Condition {
	construct new(kind) {
		super("", C_TECH, kind)
	}
}


class CBuilding is Condition {
	construct new(kind) {
		super("", C_BUILDING, kind)
	}
}

class Population {
	construct new() {
		_current = 0
		_limit = 0
		_max = 25
		_healthy = 0
		_sick = 0
	}
	add(x) { _current = _current + x }
	addLimit(x) { 
		_limit = _limit + x 
		if (_limit > _max) {
			_limit = _max
		} 
	}
	current { _current }
	max { _max }
	limit { _limit }
	ismax { 
		return _current == _max 
	}
}

class ExprItem is Base {
      construct new(insts) {
            super(C_EXPRITEM)
            _insts = insts
      }
      etype{_etype}
      insts{_insts}
}


class CV {
	addFood(x) {}
	addMoney(x) {}
	addBeaker(x) { }
	addArt(x) { }
	addHammer(x) { }
	addSymbol(x) { }
	cm{_cm}
	construct new (name, rulername) {
		_name = name
		_rulername = rulername
		_city=[]

		_cm = ConditionManager.new()

		_items = {}
		_buildings= {}
		_techs= {}		
		_buildingsByName= {}
		_slider = 80
		_capital = null
		_cv = this
		_cvid = -1
		_e = ExprIntr.new()
		init()
	}
	cv { _cv }
	cvid { _cvid }
	cvid=(v) {
		_cvid=v
	}		
	name { _name }
	techs { _techs }	
	nextclick(v) {
		eachCityOnclick() 
	}	
	nextturn(v) {
		eachCityOnturn() 
	}
	initItems() {
		var i = C_TECH_MIN
		while (i < C_TECH_MAX) {
			items[i] = Item.new(null, this,i,0)
			i = i + 1
		}
		i = C_BUILDING_MIN
		while (i < C_BUILDING_MAX) {
			items[i] = Item.new(null, this,i,0)
			i = i + 1
		}
	}
	defineResource(kind, name, title, reqs, prereqs,costs) {
		var res = CResource.new(kind,1,0)
		defineCondition(res, name, title, reqs, prereqs, costs, [], [])
		return res
	}
	rs(st,count,m) { 
		return CResource.new(st,count)		
	}
	cst(st,count) { 
		return CResource.new(st,count)
	}
	ef(st,count) { 
		return Effect.new(st,count)
	}
	initResource() {
//		_iron = defineResource(C_SRESOURCE_IRON, "iron", "iron", null, [rq(C_TECH_BRONZEWORKING,1,0)])

	}
	defineBuilding(kind, name, title, prereqs, prepays, reqs, bonus, effect) {
		var building= CBuilding.new(kind)
		defineCondition(building, name, title, prereqs, prepays, reqs, bonus, effect)	
		_buildingsByName[name] = building.subtype
		_buildings[building.subtype] = building
		return building
	}
	initBuilding() {
		var i = C_BUILDING_MIN
		while (i <= C_BUILDING_MAX) {
		      _buildings[i] = CBuilding.new(i)
		      i = i+1
		}
	}
	getCondition(kind) {
			   if (kind == 0) {
			      return 0
		           }
			   var k = _cm.kinds[kind]
			   if (k == null) {
			        return kind
			   } else if (k == C_TECH) {
			        return _techs[kind]
			   } else {
			     return kind
			   }
	}
	parsePrereqs(tech, prereqs) {
		var a = prereqs[0]
		var b = prereqs[1]
		var c = prereqs[2]
		var d = prereqs[3]
		var dp = prereqs[4]		
		var e = []
		if (d && dp) {
		   d = CondItem.new(d, dp)
		} else {
		  d = getCondition(d)
		}
		a = getCondition(a)
		b = getCondition(b)
		c = getCondition(c)		
		if (a && !b && !c && !d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, a))
		} else if (a && b && !c && !d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, a))
		      e.add(ExprOp.new(E_OP_CIVHAS, b))
		      e.add(ExprOp.new(E_OP_AND))		      		      
		} else if (a && b && c && !d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, b))
		      e.add(ExprOp.new(E_OP_CIVHAS, c))
		      e.add(ExprOp.new(E_OP_OR))		      		      		      
		      e.add(ExprOp.new(E_OP_CIVHAS, a))
		      e.add(ExprOp.new(E_OP_AND))		      		      
		} else if (a && b && c && d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, b))
		      e.add(ExprOp.new(E_OP_CIVHAS, c))
		      e.add(ExprOp.new(E_OP_OR))		      		      		      
		      e.add(ExprOp.new(E_OP_CIVHAS, d))
		      e.add(ExprOp.new(E_OP_OR))		      		      		      
		      e.add(ExprOp.new(E_OP_CIVHAS, a))
		      e.add(ExprOp.new(E_OP_AND))		      		      
		} else if (!a && b && c && !d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, b))
		      e.add(ExprOp.new(E_OP_CIVHAS, c))
		      e.add(ExprOp.new(E_OP_OR))		      		      		      
		} else if (!a && b && c && d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, b))
		      e.add(ExprOp.new(E_OP_CIVHAS, c))
		      e.add(ExprOp.new(E_OP_OR))		      		      		      
		      e.add(ExprOp.new(E_OP_CIVHAS, d))
		      e.add(ExprOp.new(E_OP_OR))		      		      		      
		} else if (a && b && !c && d) {
		      e.add(ExprOp.new(E_OP_CIVHAS, b))
		      e.add(ExprOp.new(E_OP_CIVHAS, d))
		      e.add(ExprOp.new(E_OP_AND))		      		      		      
		      e.add(ExprOp.new(E_OP_CIVHAS, a))
		      e.add(ExprOp.new(E_OP_AND))		      		      		      
		} else {
		      System.print("abort")
		}
		return ExprItem.new(e)		
	}
	parseTechPrereqs(tech, prereqs) {				
		var a = prereqs[0]
		var b = prereqs[1]
		var c = prereqs[2]
		var d = prereqs[3]
		if (a && _techs[a]) {
				tech.followedby(_techs[a])
		}
		if (b && _techs[b]) {
				tech.followedby(_techs[b])
		}
		if (c && _techs[c]) {
				tech.followedby(_techs[c])
		}
		if (d && _techs[d]) {
				tech.followedby(_techs[d])
		}
        }
	defineTech(kind, name, title, prereqs, prepays, reqs, bonus, effect) {
		var tech = _techs[kind]
		var exprinsts = parsePrereqs(tech, prereqs)
		parseTechPrereqs(tech, prereqs)		
		defineCondition(tech, name, title, exprinsts, prepays, reqs, bonus, effect)
		_items[kind] = Item.new(this, null, kind, 0)
		return tech
	}
	addReq3(targ,  prereqs, prepays, reqs) {
		if (reqs) {
			var i = 0
			while (i < reqs.count) {	
				var subtype = reqs[i]
				var count = reqs[i+1]				
				targ.add_postpay(CondItem.new(subtype,count))
				i = i+2
			}
			_cm.postpay[targ.subtype] = reqs
		}
		if (prereqs) {
			_cm.prereq[targ.subtype] = prereqs
		}
		if (prepays) {
			var i = 0
			while (i < prepays.count) {
    System.printAll([targ.subtype, " ", targ.name, " ", i, " ", prepays.count])    
				var subtype = prepays[i]
				var count = prepays[i+1]
    System.printAll([targ.subtype, " ", targ.name, " ", i, " ", subtype, " ", count, " ", prepays.count])
        System.printAll(prepays)
				targ.add_prepay(CondItem.new(subtype, count))
				i = i+2
			}
			_cm.prepay[targ.subtype] = prepays 
		}
		return targ
	}
	defineCondition(targ, name, title, prereqs, prepays, reqs, bonus, effect) {
		targ.name = name
		targ.title = title
		_cm.conditionname[targ.subtype] = name
		_cm.conditiontitle[targ.subtype] = title
		_cm.conditions[targ.subtype] = targ
		targ.bonus = bonus
		targ.effectdata = effect
		return addReq3(targ, prereqs, prepays, reqs)
	}
	techname {_techname}	
	initTech() {
		var i = C_TECH_MIN
		while (i <= C_TECH_MAX) {
		      _techs[i] = CTech.new(i)
		      _cm.kinds[i] = C_TECH
		      i = i+1
		}
//		_mining = defineTech(C_TECH_MINING, "mining", "mining", null, null, null)
//		_masory = defineTech(C_TECH_MASONRY, "masory", "masory",  null, null, null)
//		_construction = defineTech(C_TECH_CONSTRUCTION, "construction", "construction",null, null, null)
//		_bronze = defineTech(C_TECH_BRONZEWORKING, "bronse", "bronse",null, null, null)
//		System.print(_mining)
//		_mining.followedby(_masory)
//		_mining.followedby(_bronze)
//		_masory.followedby(_construction)
//		_pot = defineTech("pot", 300)
//		_fishing = defineTech("fishing", 300)
//		_agriculture = defineTech("agriculture", 300)
//		_library = defineTech("library", 300)
//		_pot.follows(_library)
	}
	initWonder() {}
	init() {
		clearOutcome() 
		initTech()
		initBuilding()
		initWonder()
		CVInit.init(this)
	}
	getPrereqOf(t) {
		var c = _cm.conditions[t]
		return c.prereq
	}
	clearOutcome() {
		_popcurrent = 0
		_food = 0
		_money = 0
		_beaker = 0
		_gear = 0
		_art = 0
		_symbol = 0
	}
	gatherCityOutcome(c) {
		_popcurrent = _popcurrent + c.pop.current
		_food = _food + c.food
		_money = _money + c.money
		_beaker = _beaker + c.beaker
		_gear = _gear + c.gear
		_art = _art + c.art
		_symbol = _symbol + c.symbol
		c.clearOutcome()
	}
	eachCity(func) {
		var i = 0
		while (i < _city.count) {
			var c = _city[i]
                        func.call(c)
			i = i+1
		}
	}
	eachCityOnclick() {
		eachCity(Fn.new { |city|
                        // city.produce_resource()				
                        city.onclick()				
		})
		
	}
	eachCityOnturn() {
		var cv = this
		eachCity(Fn.new { |city|
                        city.onturn()
			city.updatePcdata()		
		})
		eachCity(Fn.new { |city|
			cv.gatherCityOutcome(city)
		})
		updatePcdata()
	}
	eachCityDisplay() {
		eachCity(Fn.new { |city|
                        city.display()
		})
	}
	addCity(c) { 
		if (capital == null) { capital = c }
		_city.add(c) 
	}
	findCityByName(name) { 
		var i = 0
		while (i < _city.count) {
			if (_city[i].name == name) { 
				return _city[i] 
			}
			i=i+1
		}
		return null
	}
	city { 
		return _city 
	}
	buildableByName(city, name) { 
		var subtype = _buildingsByName[name]
		return city.buildableBySubtype(subtype) 
	}
	buildableBySubtype(city, name) { 
		return city.buildableBySubtype(name) 
	}
	buildStartByName(city, name) { 
		var subtype = _buildingsByName[name]
		return city.buildStartBySubtype(subtype) 	
	}
	buildStartBySubtype(city, name) { 
		return city.buildStartBySubtype(name) 
	}
	purchaseItemByName(city, name) { 
		var subtype = _buildingsByName[name]
		return city.purchaseItemBySubtype(subtype) 
	}
	purchaseItemBySubtype(city, name) { 
		return city.purchaseItemBySubtype(name)
	}
	capital { 
		return _capital 
	}	
	capital=(v) { 
		_capital = v
	}
	display() { 
		eachCityDisplay() 
		System.printAll([{"":"CV"},{"name": "CV"}, {"pop":_popcurrent}])
		System.printAll([{"":"CV"},{"food":_food},{"money": _money}, {"beaker": _beaker}, {"gear": _gear}, {"art": _art}, {"symbol": _symbol}])
	}
	calculate_cost_onturn() {
//		System.print("cv#calculate_cost_onturn()")
	}

 	findBuildingByName(name) {
		var n = _buildingsByName[name]
		if (n == null) {
			return C_COND_NONE
		}
		return n
	}
 	findBuildingBySubtype(name) {
		var n = _buildings[name]
		if (n == null) {
			return C_COND_NONE
		}
		return n
	}
	updatePcdata() {
		eachCity(Fn.new{|city| city.updatePcdata()})
	}
	execEffectOngain(effecttype, count, item, city)		{
	if (effecttype == EF__ADD_GP) {
	S.log(["EF__ADD_GP ", EF__ADD_GP])
	} else if (effecttype == EF__ADD_TRADEROUTE) {
	S.log(["EF__ADD_TRADEROUTE ", EF__ADD_TRADEROUTE])
	} else if (effecttype == EF__AVAILABLE_CIVICS) {
	S.log(["EF__AVAILABLE_CIVICS ", EF__AVAILABLE_CIVICS])
	} else if (effecttype == EF__AVAILABLE_NOANARCHY) {
	S.log(["EF__AVAILABLE_NOANARCHY ", EF__AVAILABLE_NOANARCHY])
	} else if (effecttype == EF__DEPLOY_ELECTIONBYAP) {
	S.log(["EF__DEPLOY_ELECTIONBYAP ", EF__DEPLOY_ELECTIONBYAP])
	} else if (effecttype == EF__DEPLOY_ELECTIONBYUN) {
	S.log(["EF__DEPLOY_ELECTIONBYUN ", EF__DEPLOY_ELECTIONBYUN])
	} else if (effecttype == EF__DEPLOY_ELECTIONRIGHTBYAP) {
	S.log(["EF__DEPLOY_ELECTIONRIGHTBYAP ", EF__DEPLOY_ELECTIONRIGHTBYAP])
	} else if (effecttype == EF__DEPLOY_ELECTIONRIGHTBYUN) {
	S.log(["EF__DEPLOY_ELECTIONRIGHTBYUN ", EF__DEPLOY_ELECTIONRIGHTBYUN])
	} else if (effecttype == EF__GAIN_C_PN_GREATARTIST) {
	S.log(["EF__GAIN_C_PN_GREATARTIST ", EF__GAIN_C_PN_GREATARTIST])
	} else if (effecttype == EF__GAIN_C_PN_GREATENGINEER) {
	S.log(["EF__GAIN_C_PN_GREATENGINEER ", EF__GAIN_C_PN_GREATENGINEER])
	} else if (effecttype == EF__GAIN_C_PN_GREATGENERAL) {
	S.log(["EF__GAIN_C_PN_GREATGENERAL ", EF__GAIN_C_PN_GREATGENERAL])
	} else if (effecttype == EF__GAIN_C_PN_GREATMERCHANT) {
	S.log(["EF__GAIN_C_PN_GREATMERCHANT ", EF__GAIN_C_PN_GREATMERCHANT])
	} else if (effecttype == EF__GAIN_C_PN_GREATPROPHET) {
	S.log(["EF__GAIN_C_PN_GREATPROPHET ", EF__GAIN_C_PN_GREATPROPHET])
	} else if (effecttype == EF__GAIN_C_PN_GREATSCIENTIST) {
	S.log(["EF__GAIN_C_PN_GREATSCIENTIST ", EF__GAIN_C_PN_GREATSCIENTIST])
	} else if (effecttype == EF__GAIN_C_PN_GREATSPY) {
	S.log(["EF__GAIN_C_PN_GREATSPY ", EF__GAIN_C_PN_GREATSPY])
	} else if (effecttype == EF__GAIN_MOVIE) {
	S.log(["EF__GAIN_MOVIE ", EF__GAIN_MOVIE])
	} else if (effecttype == EF__GAIN_MUSIC) {
	S.log(["EF__GAIN_MUSIC ", EF__GAIN_MUSIC])
	} else if (effecttype == EF__GAIN_MUSICAL) {
	S.log(["EF__GAIN_MUSICAL ", EF__GAIN_MUSICAL])
	} else if (effecttype == EF__GET_CITYDEFENCERATE) {
	S.log(["EF__GET_CITYDEFENCERATE ", EF__GET_CITYDEFENCERATE])
	} else if (effecttype == EF__GET_EX_NEWARMY) {
	S.log(["EF__GET_EX_NEWARMY ", EF__GET_EX_NEWARMY])
	} else if (effecttype == EF__GET_EX_NEWCLAVARY) {
	S.log(["EF__GET_EX_NEWCLAVARY ", EF__GET_EX_NEWCLAVARY])
	} else if (effecttype == EF__GET_EX_NEWSHIP) {
	S.log(["EF__GET_EX_NEWSHIP ", EF__GET_EX_NEWSHIP])
	} else if (effecttype == EF__GET_EX_NEWUNIT) {
	S.log(["EF__GET_EX_NEWUNIT ", EF__GET_EX_NEWUNIT])
	} else if (effecttype == EF__GET_GOLDENAGE) {
	S.log(["EF__GET_GOLDENAGE ", EF__GET_GOLDENAGE])
	} else if (effecttype == EF__GET_LABOR_OPERATION_SPEED) {
	S.log(["EF__GET_LABOR_OPERATION_SPEED ", EF__GET_LABOR_OPERATION_SPEED])
	} else if (effecttype == EF__GET_TECH) {
	S.log(["EF__GET_TECH ", EF__GET_TECH])
	} else if (effecttype == EF__MULT_GOALDENAGE) {
	S.log(["EF__MULT_GOALDENAGE ", EF__MULT_GOALDENAGE])
	} else if (effecttype == EF__MULT_GP) {
	S.log(["EF__MULT_GP ", EF__MULT_GP])
	} else if (effecttype == EF__MULT_LABORSPEED) {
	S.log(["EF__MULT_LABORSPEED ", EF__MULT_LABORSPEED])
	} else if (effecttype == EF__MULTFORMILLITARY_GEAR) {
	S.log(["EF__MULTFORMILLITARY_GEAR ", EF__MULTFORMILLITARY_GEAR])
	} else if (effecttype == EF__MULTIPLY_CITYARTILLERYDAMAGE) {
	S.log(["EF__MULTIPLY_CITYARTILLERYDAMAGE ", EF__MULTIPLY_CITYARTILLERYDAMAGE])
	} else if (effecttype == EF__MULTIPLY_CITYFEE) {
	S.log(["EF__MULTIPLY_CITYFEE ", EF__MULTIPLY_CITYFEE])
	} else if (effecttype == EF__MULTIPLY_PROTECTESPIONAGE) {
	S.log(["EF__MULTIPLY_PROTECTESPIONAGE ", EF__MULTIPLY_PROTECTESPIONAGE])
	} else if (effecttype == EF__REDUCE_CITYFEE) {
	S.log(["EF__REDUCE_CITYFEE ", EF__REDUCE_CITYFEE])
	} else if (effecttype == EF__REDUCE_UNHAPPINESS) {
	S.log(["EF__REDUCE_UNHAPPINESS ", EF__REDUCE_UNHAPPINESS])
	} else if (effecttype == EF_ADD_ART) {
	S.log(["EF_ADD_ART ", EF_ADD_ART])
	} else if (effecttype == EF_ADD_BEAKER) {
	S.log(["EF_ADD_BEAKER ", EF_ADD_BEAKER])
	} else if (effecttype == EF_ADD_COIN) {
	S.log(["EF_ADD_COIN ", EF_ADD_COIN])
	} else if (effecttype == EF_ADD_COINPC) {
	S.log(["EF_ADD_COINPC ", EF_ADD_COINPC])
	} else if (effecttype == EF_ADD_COMPLAIN) {
	S.log(["EF_ADD_COMPLAIN ", EF_ADD_COMPLAIN])
	} else if (effecttype == EF_ADD_ENEGY) {
	S.log(["EF_ADD_ENEGY ", EF_ADD_ENEGY])
	} else if (effecttype == EF_ADD_ESPONAGE) {
	S.log(["EF_ADD_ESPONAGE ", EF_ADD_ESPONAGE])
	} else if (effecttype == EF_ADD_FAITH) {
	S.log(["EF_ADD_FAITH ", EF_ADD_FAITH])
	} else if (effecttype == EF_ADD_FAITHPC) {
	S.log(["EF_ADD_FAITHPC ", EF_ADD_FAITHPC])
	} else if (effecttype == EF_ADD_FIRE) {
	S.log(["EF_ADD_FIRE ", EF_ADD_FIRE])
	} else if (effecttype == EF_ADD_FIREPC) {
	S.log(["EF_ADD_FIREPC ", EF_ADD_FIREPC])
	} else if (effecttype == EF_ADD_FOOD) {
	S.log(["EF_ADD_FOOD ", EF_ADD_FOOD])
	} else if (effecttype == EF_ADD_GEAR) {
	S.log(["EF_ADD_GEAR ", EF_ADD_GEAR])
	} else if (effecttype == EF_ADD_HAMMER) {
	S.log(["EF_ADD_HAMMER ", EF_ADD_HAMMER])
	} else if (effecttype == EF_ADD_HAMMERPC) {
	S.log(["EF_ADD_HAMMERPC ", EF_ADD_HAMMERPC])
	} else if (effecttype == EF_ADD_HAPPINESS) {
	S.log(["EF_ADD_HAPPINESS ", EF_ADD_HAPPINESS])
	} else if (effecttype == EF_ADD_HEALTHY) {
	S.log(["EF_ADD_HEALTHY ", EF_ADD_HEALTHY])
	} else if (effecttype == EF_ADD_INFO) {
	S.log(["EF_ADD_INFO ", EF_ADD_INFO])
	} else if (effecttype == EF_ADD_INFOPC) {
	S.log(["EF_ADD_INFOPC ", EF_ADD_INFOPC])
	} else if (effecttype == EF_ADD_MONEY) {
	S.log(["EF_ADD_MONEY ", EF_ADD_MONEY])
	} else if (effecttype == EF_ADD_PAN) {
	S.log(["EF_ADD_PAN ", EF_ADD_PAN])
	} else if (effecttype == EF_ADD_PANPC) {
	S.log(["EF_ADD_PANPC ", EF_ADD_PANPC])
	} else if (effecttype == EF_ADD_SYMBOL) {
	S.log(["EF_ADD_SYMBOL ", EF_ADD_SYMBOL])
	} else if (effecttype == EF_ADD_UNHEALTHY) {
	S.log(["EF_ADD_UNHEALTHY ", EF_ADD_UNHEALTHY])
	} else if (effecttype == EF_AFTERGUNPOWDERUNIT_NOT_DAMAGERATE) {
	S.log(["EF_AFTERGUNPOWDERUNIT_NOT_DAMAGERATE ", EF_AFTERGUNPOWDERUNIT_NOT_DAMAGERATE])
	} else if (effecttype == EF_ALL_AVAILABLE_GOVERMENT) {
	S.log(["EF_ALL_AVAILABLE_GOVERMENT ", EF_ALL_AVAILABLE_GOVERMENT])
	} else if (effecttype == EF_ALL_AVAILABLE_RELIGIONCIVICS) {
	S.log(["EF_ALL_AVAILABLE_RELIGIONCIVICS ", EF_ALL_AVAILABLE_RELIGIONCIVICS])
	} else if (effecttype == EF_ALL_FIRST_NATIONAL_RELIGION_BUILDING_GET_GEAR) {
	S.log(["EF_ALL_FIRST_NATIONAL_RELIGION_BUILDING_GET_GEAR ", EF_ALL_FIRST_NATIONAL_RELIGION_BUILDING_GET_GEAR])
	} else if (effecttype == EF_ALL_NATIONAL_RELIGION_BUILDING_GET_ART) {
	S.log(["EF_ALL_NATIONAL_RELIGION_BUILDING_GET_ART ", EF_ALL_NATIONAL_RELIGION_BUILDING_GET_ART])
	} else if (effecttype == EF_ALL_NATIONAL_RELIGION_BUILDING_GET_BEAKER) {
	S.log(["EF_ALL_NATIONAL_RELIGION_BUILDING_GET_BEAKER ", EF_ALL_NATIONAL_RELIGION_BUILDING_GET_BEAKER])
	} else if (effecttype == EF_ALL_NATIONAL_RELIGION_BUILDING_GET_MONEY) {
	S.log(["EF_ALL_NATIONAL_RELIGION_BUILDING_GET_MONEY ", EF_ALL_NATIONAL_RELIGION_BUILDING_GET_MONEY])
	} else if (effecttype == EF_ALLCITY_DEPLOY_BROADCASTTOWER) {
	S.log(["EF_ALLCITY_DEPLOY_BROADCASTTOWER ", EF_ALLCITY_DEPLOY_BROADCASTTOWER])
	} else if (effecttype == EF_ALLCITY_DEPLOY_ELEC) {
	S.log(["EF_ALLCITY_DEPLOY_ELEC ", EF_ALLCITY_DEPLOY_ELEC])
	} else if (effecttype == EF_ALLCITY_DEPLOY_MONUMENT) {
	S.log(["EF_ALLCITY_DEPLOY_MONUMENT ", EF_ALLCITY_DEPLOY_MONUMENT])
	} else if (effecttype == EF_ALLCITY_GAIN_BROADCASTTOWER) {
	S.log(["EF_ALLCITY_GAIN_BROADCASTTOWER ", EF_ALLCITY_GAIN_BROADCASTTOWER])
	} else if (effecttype == EF_ALLCITY_GAIN_HEALTHY) {
	S.log(["EF_ALLCITY_GAIN_HEALTHY ", EF_ALLCITY_GAIN_HEALTHY])
	} else if (effecttype == EF_ALLCITY_GAIN_MONUMENT) {
	S.log(["EF_ALLCITY_GAIN_MONUMENT ", EF_ALLCITY_GAIN_MONUMENT])
	} else if (effecttype == EF_ALLCITY_GET_DEFENSERATE) {
	S.log(["EF_ALLCITY_GET_DEFENSERATE ", EF_ALLCITY_GET_DEFENSERATE])
	} else if (effecttype == EF_ALLCITY_GET_GP) {
	S.log(["EF_ALLCITY_GET_GP ", EF_ALLCITY_GET_GP])
	} else if (effecttype == EF_ALLCITY_GET_POP) {
	S.log(["EF_ALLCITY_GET_POP ", EF_ALLCITY_GET_POP])
	} else if (effecttype == EF_ALLCITY_MULT_GP) {
	S.log(["EF_ALLCITY_MULT_GP ", EF_ALLCITY_MULT_GP])
	} else if (effecttype == EF_ALLCITY_ON_SAME_CONTINENT_GET_SPECIALIST) {
	S.log(["EF_ALLCITY_ON_SAME_CONTINENT_GET_SPECIALIST ", EF_ALLCITY_ON_SAME_CONTINENT_GET_SPECIALIST])
	} else if (effecttype == EF_ALLCITYATWAR_REDUCE_UNHAPPINESS) {
	S.log(["EF_ALLCITYATWAR_REDUCE_UNHAPPINESS ", EF_ALLCITYATWAR_REDUCE_UNHAPPINESS])
	} else if (effecttype == EF_AROUND_CITY_FEE_MULT_MONEY) {
	S.log(["EF_AROUND_CITY_FEE_MULT_MONEY ", EF_AROUND_CITY_FEE_MULT_MONEY])
	} else if (effecttype == EF_BANANA_GAIN_HEALTHY) {
	S.log(["EF_BANANA_GAIN_HEALTHY ", EF_BANANA_GAIN_HEALTHY])
	} else if (effecttype == EF_BLACKSMITH_GET_GEAR) {
	S.log(["EF_BLACKSMITH_GET_GEAR ", EF_BLACKSMITH_GET_GEAR])
	} else if (effecttype == EF_BUILDING_MILLITARY_MULTIPLY_GEAR) {
	S.log(["EF_BUILDING_MILLITARY_MULTIPLY_GEAR ", EF_BUILDING_MILLITARY_MULTIPLY_GEAR])
	} else if (effecttype == EF_C_LEGAL_NATIONHOOD_GAIN_HAPPINESS) {
	S.log(["EF_C_LEGAL_NATIONHOOD_GAIN_HAPPINESS ", EF_C_LEGAL_NATIONHOOD_GAIN_HAPPINESS])
	} else if (effecttype == EF_CARISMA_ADD_HAPPINESS) {
	S.log(["EF_CARISMA_ADD_HAPPINESS ", EF_CARISMA_ADD_HAPPINESS])
	} else if (effecttype == EF_CITY_BECOME_CAPITAL) {
	S.log(["EF_CITY_BECOME_CAPITAL ", EF_CITY_BECOME_CAPITAL])
	} else if (effecttype == EF_CITY_REDUCE_UNHAPPINESS) {
	S.log(["EF_CITY_REDUCE_UNHAPPINESS ", EF_CITY_REDUCE_UNHAPPINESS])
	} else if (effecttype == EF_CITY_UNAVAILABLE_COAL) {
	S.log(["EF_CITY_UNAVAILABLE_COAL ", EF_CITY_UNAVAILABLE_COAL])
	} else if (effecttype == EF_CLAM_GAIN_HEALTHY) {
	S.log(["EF_CLAM_GAIN_HEALTHY ", EF_CLAM_GAIN_HEALTHY])
	} else if (effecttype == EF_COAL_GAIN_ELEC) {
	S.log(["EF_COAL_GAIN_ELEC ", EF_COAL_GAIN_ELEC])
	} else if (effecttype == EF_COAL_GAIN_UNHEALTHY) {
	S.log(["EF_COAL_GAIN_UNHEALTHY ", EF_COAL_GAIN_UNHEALTHY])
	} else if (effecttype == EF_COAL_MULT_GEAR) {
	S.log(["EF_COAL_MULT_GEAR ", EF_COAL_MULT_GEAR])
	} else if (effecttype == EF_COASTCITY_GET_TRADEROUTE) {
	S.log(["EF_COASTCITY_GET_TRADEROUTE ", EF_COASTCITY_GET_TRADEROUTE])
	} else if (effecttype == EF_COASTTILE_ADD_COIN) {
	S.log(["EF_COASTTILE_ADD_COIN ", EF_COASTTILE_ADD_COIN])
	} else if (effecttype == EF_CORN_GAIN_HEALTHY) {
	S.log(["EF_CORN_GAIN_HEALTHY ", EF_CORN_GAIN_HEALTHY])
	} else if (effecttype == EF_COW_GAIN_HEALTHY) {
	S.log(["EF_COW_GAIN_HEALTHY ", EF_COW_GAIN_HEALTHY])
	} else if (effecttype == EF_CRAB_GAIN_HEALTHY) {
	S.log(["EF_CRAB_GAIN_HEALTHY ", EF_CRAB_GAIN_HEALTHY])
	} else if (effecttype == EF_CULTUREEACHRATE10POINTS_GET_HAPPINESS) {
	S.log(["EF_CULTUREEACHRATE10POINTS_GET_HAPPINESS ", EF_CULTUREEACHRATE10POINTS_GET_HAPPINESS])
	} else if (effecttype == EF_CULTUREEACHRATE20POINTS_GET_HAPPINESS) {
	S.log(["EF_CULTUREEACHRATE20POINTS_GET_HAPPINESS ", EF_CULTUREEACHRATE20POINTS_GET_HAPPINESS])
	} else if (effecttype == EF_CULTUREEACHRATE5POINTS_GET_HAPPINESS) {
	S.log(["EF_CULTUREEACHRATE5POINTS_GET_HAPPINESS ", EF_CULTUREEACHRATE5POINTS_GET_HAPPINESS])
	} else if (effecttype == EF_DEER_GAIN_HEALTHY) {
	S.log(["EF_DEER_GAIN_HEALTHY ", EF_DEER_GAIN_HEALTHY])
	} else if (effecttype == EF_DEPLOY_C_PN_ARTIST) {
	S.log(["EF_DEPLOY_C_PN_ARTIST ", EF_DEPLOY_C_PN_ARTIST])
	} else if (effecttype == EF_DEPLOY_C_PN_ENGINEER) {
	S.log(["EF_DEPLOY_C_PN_ENGINEER ", EF_DEPLOY_C_PN_ENGINEER])
	} else if (effecttype == EF_DEPLOY_C_PN_GENERAL) {
	S.log(["EF_DEPLOY_C_PN_GENERAL ", EF_DEPLOY_C_PN_GENERAL])
	} else if (effecttype == EF_DEPLOY_C_PN_MERCHANT) {
	S.log(["EF_DEPLOY_C_PN_MERCHANT ", EF_DEPLOY_C_PN_MERCHANT])
	} else if (effecttype == EF_DEPLOY_C_PN_PRIEST) {
	S.log(["EF_DEPLOY_C_PN_PRIEST ", EF_DEPLOY_C_PN_PRIEST])
	} else if (effecttype == EF_DEPLOY_C_PN_SCIENTIST) {
	S.log(["EF_DEPLOY_C_PN_SCIENTIST ", EF_DEPLOY_C_PN_SCIENTIST])
	} else if (effecttype == EF_DEPLOY_C_PN_SPY) {
	S.log(["EF_DEPLOY_C_PN_SPY ", EF_DEPLOY_C_PN_SPY])
	} else if (effecttype == EF_DYE_GAIN_HAPPINESS) {
	S.log(["EF_DYE_GAIN_HAPPINESS ", EF_DYE_GAIN_HAPPINESS])
	} else if (effecttype == EF_EACHMANAGEDFOREST_GAIN_SPECIALIST) {
	S.log(["EF_EACHMANAGEDFOREST_GAIN_SPECIALIST ", EF_EACHMANAGEDFOREST_GAIN_SPECIALIST])
	} else if (effecttype == EF_EACHORIGINALSTATERELIGIONBUILDING_ADD_GEAR) {
	S.log(["EF_EACHORIGINALSTATERELIGIONBUILDING_ADD_GEAR ", EF_EACHORIGINALSTATERELIGIONBUILDING_ADD_GEAR])
	} else if (effecttype == EF_EACHPRIEST_ADD_GEAR) {
	S.log(["EF_EACHPRIEST_ADD_GEAR ", EF_EACHPRIEST_ADD_GEAR])
	} else if (effecttype == EF_EACHSPECIALISTOFALLCITY_ADD_ART) {
	S.log(["EF_EACHSPECIALISTOFALLCITY_ADD_ART ", EF_EACHSPECIALISTOFALLCITY_ADD_ART])
	} else if (effecttype == EF_EACHSTATERELIGIONBUILDING_ADD_ART) {
	S.log(["EF_EACHSTATERELIGIONBUILDING_ADD_ART ", EF_EACHSTATERELIGIONBUILDING_ADD_ART])
	} else if (effecttype == EF_EACHSTATERELIGIONBUILDING_ADD_GEAR) {
	S.log(["EF_EACHSTATERELIGIONBUILDING_ADD_GEAR ", EF_EACHSTATERELIGIONBUILDING_ADD_GEAR])
	} else if (effecttype == EF_EACHSTATERELIGIONBUILDING_ADD_BEAKER) {
	S.log(["EF_EACHSTATERELIGIONBUILDING_ADD_BEAKER ", EF_EACHSTATERELIGIONBUILDING_ADD_BEAKER])
	} else if (effecttype == EF_EACHSTATERELIGIONBUILDING_ADD_MONEY) {
	S.log(["EF_EACHSTATERELIGIONBUILDING_ADD_MONEY ", EF_EACHSTATERELIGIONBUILDING_ADD_MONEY])
	} else if (effecttype == EF_ELEC_MULT_GEAR) {
	S.log(["EF_ELEC_MULT_GEAR ", EF_ELEC_MULT_GEAR])
	} else if (effecttype == EF_ELEPHANT_GAIN_HAPPINESS) {
	S.log(["EF_ELEPHANT_GAIN_HAPPINESS ", EF_ELEPHANT_GAIN_HAPPINESS])
	} else if (effecttype == EF_ENVIRONMETISM_GAIN_HEALTHY) {
	S.log(["EF_ENVIRONMETISM_GAIN_HEALTHY ", EF_ENVIRONMETISM_GAIN_HEALTHY])
	} else if (effecttype == EF_FISH_GAIN_HEALTHY) {
	S.log(["EF_FISH_GAIN_HEALTHY ", EF_FISH_GAIN_HEALTHY])
	} else if (effecttype == EF_FROM_BUILDING_GAIN_COMPLAIN) {
	S.log(["EF_FROM_BUILDING_GAIN_COMPLAIN ", EF_FROM_BUILDING_GAIN_COMPLAIN])
	} else if (effecttype == EF_FROM_BUILDING_GAIN_UNHEALTHY) {
	S.log(["EF_FROM_BUILDING_GAIN_UNHEALTHY ", EF_FROM_BUILDING_GAIN_UNHEALTHY])
	} else if (effecttype == EF_FUR_GAIN_HAPPINESS) {
	S.log(["EF_FUR_GAIN_HAPPINESS ", EF_FUR_GAIN_HAPPINESS])
	} else if (effecttype == EF_GAIN_C_PN_ARTIST_SLOT) {
	S.log(["EF_GAIN_C_PN_ARTIST_SLOT ", EF_GAIN_C_PN_ARTIST_SLOT])
	} else if (effecttype == EF_GAIN_C_PN_ENGINEER_SLOT) {
	S.log(["EF_GAIN_C_PN_ENGINEER_SLOT ", EF_GAIN_C_PN_ENGINEER_SLOT])
	} else if (effecttype == EF_GAIN_C_PN_GENERAL_SLOT) {
	S.log(["EF_GAIN_C_PN_GENERAL_SLOT ", EF_GAIN_C_PN_GENERAL_SLOT])
	} else if (effecttype == EF_GAIN_C_PN_MERCHANT_SLOT) {
	S.log(["EF_GAIN_C_PN_MERCHANT_SLOT ", EF_GAIN_C_PN_MERCHANT_SLOT])
	} else if (effecttype == EF_GAIN_C_PN_PRIEST_SLOT) {
	S.log(["EF_GAIN_C_PN_PRIEST_SLOT ", EF_GAIN_C_PN_PRIEST_SLOT])
	} else if (effecttype == EF_GAIN_C_PN_SCIENTIST_SLOT) {
	S.log(["EF_GAIN_C_PN_SCIENTIST_SLOT ", EF_GAIN_C_PN_SCIENTIST_SLOT])
	} else if (effecttype == EF_GAIN_C_PN_SPY_SLOT) {
	S.log(["EF_GAIN_C_PN_SPY_SLOT ", EF_GAIN_C_PN_SPY_SLOT])
	} else if (effecttype == EF_GAIN_POPLIMIT) {
	S.log(["EF_GAIN_POPLIMIT ", EF_GAIN_POPLIMIT])
	} else if (effecttype == EF_GARISSON_MULTIPLY_HEAL) {
	S.log(["EF_GARISSON_MULTIPLY_HEAL ", EF_GARISSON_MULTIPLY_HEAL])
	} else if (effecttype == EF_GEMS_GAIN_HAPPINESS) {
	S.log(["EF_GEMS_GAIN_HAPPINESS ", EF_GEMS_GAIN_HAPPINESS])
	} else if (effecttype == EF_GOLD_GAIN_HAPPINESS) {
	S.log(["EF_GOLD_GAIN_HAPPINESS ", EF_GOLD_GAIN_HAPPINESS])
	} else if (effecttype == EF_GRANARY_GET_GRANARY) {
	S.log(["EF_GRANARY_GET_GRANARY ", EF_GRANARY_GET_GRANARY])
	} else if (effecttype == EF_HOURSE_GAIN_HAPPINESS) {
	S.log(["EF_HOURSE_GAIN_HAPPINESS ", EF_HOURSE_GAIN_HAPPINESS])
	} else if (effecttype == EF_IRON_MULT_GEAR) {
	S.log(["EF_IRON_MULT_GEAR ", EF_IRON_MULT_GEAR])
	} else if (effecttype == EF_MOVIE_GAIN_HAPPINESS) {
	S.log(["EF_MOVIE_GAIN_HAPPINESS ", EF_MOVIE_GAIN_HAPPINESS])
	} else if (effecttype == EF_MULT_ART) {
	S.log(["EF_MULT_ART ", EF_MULT_ART])
	} else if (effecttype == EF_MULT_BEAKER) {
	S.log(["EF_MULT_BEAKER ", EF_MULT_BEAKER])
	} else if (effecttype == EF_MULT_COIN) {
	S.log(["EF_MULT_COIN ", EF_MULT_COIN])
	} else if (effecttype == EF_MULT_COINPC) {
	S.log(["EF_MULT_COINPC ", EF_MULT_COINPC])
	} else if (effecttype == EF_MULT_ENEGY) {
	S.log(["EF_MULT_ENEGY ", EF_MULT_ENEGY])
	} else if (effecttype == EF_MULT_ESPONAGE) {
	S.log(["EF_MULT_ESPONAGE ", EF_MULT_ESPONAGE])
	} else if (effecttype == EF_MULT_FAITH) {
	S.log(["EF_MULT_FAITH ", EF_MULT_FAITH])
	} else if (effecttype == EF_MULT_FAITHPC) {
	S.log(["EF_MULT_FAITHPC ", EF_MULT_FAITHPC])
	} else if (effecttype == EF_MULT_FIRE) {
	S.log(["EF_MULT_FIRE ", EF_MULT_FIRE])
	} else if (effecttype == EF_MULT_FIREPC) {
	S.log(["EF_MULT_FIREPC ", EF_MULT_FIREPC])
	} else if (effecttype == EF_MULT_FOOD) {
	S.log(["EF_MULT_FOOD ", EF_MULT_FOOD])
	} else if (effecttype == EF_MULT_GEAR) {
	S.log(["EF_MULT_GEAR ", EF_MULT_GEAR])
	} else if (effecttype == EF_MULT_HAMMERPC) {
	S.log(["EF_MULT_HAMMERPC ", EF_MULT_HAMMERPC])
	} else if (effecttype == EF_MULT_INFO) {
	S.log(["EF_MULT_INFO ", EF_MULT_INFO])
	} else if (effecttype == EF_MULT_INFOPC) {
	S.log(["EF_MULT_INFOPC ", EF_MULT_INFOPC])
	} else if (effecttype == EF_MULT_MONEY) {
	S.log(["EF_MULT_MONEY ", EF_MULT_MONEY])
	} else if (effecttype == EF_MULT_PAN) {
	S.log(["EF_MULT_PAN ", EF_MULT_PAN])
	} else if (effecttype == EF_MULT_PANPC) {
	S.log(["EF_MULT_PANPC ", EF_MULT_PANPC])
	} else if (effecttype == EF_MULT_SYMBOL) {
	S.log(["EF_MULT_SYMBOL ", EF_MULT_SYMBOL])
	} else if (effecttype == EF_MUSIC_GAIN_HAPPINESS) {
	S.log(["EF_MUSIC_GAIN_HAPPINESS ", EF_MUSIC_GAIN_HAPPINESS])
	} else if (effecttype == EF_MUSICAL_GAIN_HAPPINESS) {
	S.log(["EF_MUSICAL_GAIN_HAPPINESS ", EF_MUSICAL_GAIN_HAPPINESS])
	} else if (effecttype == EF_NEWUNIT_GAIN_HEALSKILL) {
	S.log(["EF_NEWUNIT_GAIN_HEALSKILL ", EF_NEWUNIT_GAIN_HEALSKILL])
	} else if (effecttype == EF_NONE) {
	S.log(["EF_NONE ", EF_NONE])
	} else if (effecttype == EF_OIL_GAIN_HEALTHY) {
	S.log(["EF_OIL_GAIN_HEALTHY ", EF_OIL_GAIN_HEALTHY])
	} else if (effecttype == EF_OIL_GAIN_UNHEALTHY) {
	S.log(["EF_OIL_GAIN_UNHEALTHY ", EF_OIL_GAIN_UNHEALTHY])
	} else if (effecttype == EF_PIG_GAIN_HEALTHY) {
	S.log(["EF_PIG_GAIN_HEALTHY ", EF_PIG_GAIN_HEALTHY])
	} else if (effecttype == EF_POP_NO_UNHEALTHY) {
	S.log(["EF_POP_NO_UNHEALTHY ", EF_POP_NO_UNHEALTHY])
	} else if (effecttype == EF_RICE_GAIN_HEALTHY) {
	S.log(["EF_RICE_GAIN_HEALTHY ", EF_RICE_GAIN_HEALTHY])
	} else if (effecttype == EF_RIVERTILE_GAIN_COIN) {
	S.log(["EF_RIVERTILE_GAIN_COIN ", EF_RIVERTILE_GAIN_COIN])
	} else if (effecttype == EF_SEATILE_ADD_COIN) {
	S.log(["EF_SEATILE_ADD_COIN ", EF_SEATILE_ADD_COIN])
	} else if (effecttype == EF_SEATILEOFALLCITY_GET_COIN) {
	S.log(["EF_SEATILEOFALLCITY_GET_COIN ", EF_SEATILEOFALLCITY_GET_COIN])
	} else if (effecttype == EF_SHEEP_GAIN_HEALTHY) {
	S.log(["EF_SHEEP_GAIN_HEALTHY ", EF_SHEEP_GAIN_HEALTHY])
	} else if (effecttype == EF_SILK_GAIN_HAPPINESS) {
	S.log(["EF_SILK_GAIN_HAPPINESS ", EF_SILK_GAIN_HAPPINESS])
	} else if (effecttype == EF_SILVER_GAIN_HAPPINESS) {
	S.log(["EF_SILVER_GAIN_HAPPINESS ", EF_SILVER_GAIN_HAPPINESS])
	} else if (effecttype == EF_SPACESHIPPARTS_MULTIPLY_GEAR) {
	S.log(["EF_SPACESHIPPARTS_MULTIPLY_GEAR ", EF_SPACESHIPPARTS_MULTIPLY_GEAR])
	} else if (effecttype == EF_SPICE_GAIN_HEALTHY) {
	S.log(["EF_SPICE_GAIN_HEALTHY ", EF_SPICE_GAIN_HEALTHY])
	} else if (effecttype == EF_SUGER_GAIN_HEALTHY) {
	S.log(["EF_SUGER_GAIN_HEALTHY ", EF_SUGER_GAIN_HEALTHY])
	} else if (effecttype == EF_TRADEROUTE_ADD_COIN) {
	S.log(["EF_TRADEROUTE_ADD_COIN ", EF_TRADEROUTE_ADD_COIN])
	} else if (effecttype == EF_TRADEROUTE_MULT_COIN) {
	S.log(["EF_TRADEROUTE_MULT_COIN ", EF_TRADEROUTE_MULT_COIN])
	} else if (effecttype == EF_TRADEROUTEEXPORT_MULT_COIN) {
	S.log(["EF_TRADEROUTEEXPORT_MULT_COIN ", EF_TRADEROUTEEXPORT_MULT_COIN])
	} else if (effecttype == EF_URAN_GAIN_ELEC) {
	S.log(["EF_URAN_GAIN_ELEC ", EF_URAN_GAIN_ELEC])
	} else if (effecttype == EF_URGENTPRODUCTCAST_MULT_GEAR) {
	S.log(["EF_URGENTPRODUCTCAST_MULT_GEAR ", EF_URGENTPRODUCTCAST_MULT_GEAR])
	} else if (effecttype == EF_WHEEL_GAIN_HAPPINESS) {
	S.log(["EF_WHEEL_GAIN_HAPPINESS ", EF_WHEEL_GAIN_HAPPINESS])
	} else if (effecttype == EF_WHIP_GAIN_HEALTHY) {
	S.log(["EF_WHIP_GAIN_HEALTHY ", EF_WHIP_GAIN_HEALTHY])
	} else if (effecttype == EF_WINE_GAIN_HEALTHY) {
	S.log(["EF_WINE_GAIN_HEALTHY ", EF_WINE_GAIN_HEALTHY])
	} else if (effecttype == EF_ALLCIV_GAIN_NUCLEAR) {
	S.log(["EF_ALLCIV_GAIN_NUCLEAR ", EF_ALLCIV_GAIN_NUCLEAR])
	} else if (effecttype == EF_ALLCITY_GAIN_DEFENSERATEFORNUCLEARATTACK) {
	S.log(["EF_ALLCITY_GAIN_DEFENSERATEFORNUCLEARATTACK ", EF_ALLCITY_GAIN_DEFENSERATEFORNUCLEARATTACK])
	} else if (effecttype == EF_CIV_GAIN_COMMONTECH) {
	S.log(["EF_CIV_GAIN_COMMONTECH ", EF_CIV_GAIN_COMMONTECH])
	} else {
	S.log("NO")
	}
	}
	doEffectOngain(effectdata, item, city) {
			     var i = 0
			     while (i < effectdata.count) {
			     	   var effecttype = effectdata[i]
			     	   var count = effectdata[i+1]				   

				   execEffectOngain(effecttype, count, item, city)
				   
			     	   i = i+2
			     }
	}
}

var TILE_NONE=0
var TILE_PLANE=1
var TILE_TROPICAL=2
var TILE_DESSERT=4
var TILE_SNOW=8
var TILE_LOWEST=128
var TILE_LOW=256
var TILE_MIDDLE=512
var TILE_HIGH=1024
var TILE_TOROPICAL=2048
var TILE_PALACE=5096
var TILE_RESIDENCE=1
var TILE_FACTORY=2
var TILE_MINE=4



class Tile {
	construct new(t,u) {
		if (t == TILE_NONE) {
			t = TILE_PLANE
			u = TILE_NONE
		}
		_name = "plane"
		_terrain = t
		_height = TILE_LOW
		_upper = u
		_upperlevel = 0
		_traffic = TILE_NONE
		_mountainside = 0
		_waterside = 0
		_seaside = 0
		_forest = 0
		_resource = null
		_pan_pc = 0
		_hammer_pc = 0
		_coin_pc = 0
		_wisdom_pc = 0
		_info_pc  = 0
		_faith_pc = 0
		_upperturn = 0
		_changeupperturn = -1 
		_changeupperto = TILE_NONE	
		_assigned = 0
		_city = null
		_cityid = -1
	}
	addpcdata(a1,a2,a3,a4,a5,a6) {
		_pan_pc = _pan_pc + a1
		_hammer_pc = _hammer_pc + a2
		_coin_pc = _coin_pc + a3
		_wisdom_pc = _wisdom_pc + a4
		_info_pc  = _info_pc + a5
		_faith_pc = _faith_pc + a6
	}
	assigned { _assigned }
	assigned=(v) { 
		_assigned = v 
	}
	terrain{_terrain}
	upper{_upper}
	upper=(v){_upper=v}
	updatePcdata() {
		_coin_pc = 0
		_pan_pc = 0
		_hammer_pc = 0
		_wisdom_pc = 0
		_info_pc  = 0
		_faith_pc = 0
		if (_terrain == TILE_PLANE) {
			addpcdata(2,0,0,0,0,0)
		} else if (_terrain == TILE_TOROPICAL) {
			addpcdata(0,0,0,0,-1,0)
		} else if (_terrain == TILE_DESSERT) {
			addpcdata(0,0,0,0,0,1)
		} else if (_terrain == TILE_SNOW) {
			addpcdata(0,0,0,0,0,1)
		}
		if (_height == TILE_LOWEST) {
			if (_terrain == TILE_PLANE) {
				addpcdata(1,0,0,0,0,0)
			}
		} else if (_height == TILE_LOW) {
		//	addpcdata(0,0,0,0,0,0)
		} else if (_height == TILE_MIDDLE) {
			if (_terrain == TILE_PLANE) {
				addpcdata(0,1,0,0,0,0)
			}
		} else if (_height == TILE_HIGH) {
			addpcdata(0,0,0,0,0,0)
		}
		if (_upper == TILE_PALACE) {
			addpcdata(0,1,2,1,1,1)
		} else if (_upper == TILE_RESIDENCE) { 
			addpcdata(0,2,2+_upperlevel,1,1,1)
		} else if (_upper == TILE_FACTORY) { 
			addpcdata(-2,2+_upperlevel,0,1,1,1)
		} else if (_upper == TILE_MINE) { 
			addpcdata(-2,2,0,1,1,1)
		}
		addpcdata(_seaside|_waterside,_forest,_seaside,0,0,0)
	}
	coin_pc {_coin_pc}
	pan_pc {_pan_pc}
	hammer_pc {_hammer_pc}
	wisdom_pc {_wisdom_pc}
	info_pc{_info_pc}
	faith_pc{_faith_pc}
	getpc() {
		return [_pan_pc,_hammer_pc,_coin_pc,_wisdom_pc, _info_pc, _faith_pc]
	}
	display() {
		if (_assigned == 1) {
			System.printAll([getpc()])
		}
	}
	construct new() {}
}

class CityEffect {
        construct new() {
		_perturn_addop = {}
		_perturn_multop = {}		
	}
	perturn_addop{_perturn_addop}
	perturn_multop{_perturn_multop}		
		
}

class City {
	addPan(x) {}
	addHammer(x) {}
	addCoin(x) { }
	addWisdom(x) { }
	addInfo(x) { }
	addFaith(x) { }
	cv{_cv}
	name{_name}
	title{_title}
	producting{_producting}
	construct new (cv,name) {
		_cf = CityEffect.new()
		_cv = cv
		_name = name
		_rulername = "def"
		_pan_pc = 2
		_hammer_pc = 2
		_coin_pc = 2
		_wisdom_pc = 1
		_info_pc  = 1
		_faith_pc = 1
		_pan = 0
		_hammer = 0
		_coin = 0
		_wisdom = 0
		_info  = 0
		_faith = 0
		_food = 0
		_money = 0
		_beaker = 0
		_gear = 0
		_art = 0
		_symbol = 0
		_city=[]
		_items = {}
		_m_percent = 0.6
		_r_percent = 0.3
		_c_percent = 0.1
		_producting = null
		_tiles = []
		_foodstock = 0
		_granary = 0
		_pop = Population.new()
		_cityid = -1
		inittile()
		initpop()
		//System.print("ok")
	}
	initpop() {
		_pop.addLimit(1)
		_pop.add(1)
		autoAssignToTile()
	}
	clearpcdata() {
		_pan_pc = 0
		_hammer_pc = 0
		_coin_pc = 0
		_wisdom_pc = 0
		_info_pc  = 0
		_faith_pc = 0
	}
	gatherTilePcdata(tile) {
		if (tile.assigned == 0) return
		//System.print("gatherTilePcdata(tile)") 
		_pan_pc = _pan_pc + tile.pan_pc
		_hammer_pc = _hammer_pc + tile.hammer_pc
		_coin_pc = _coin_pc + tile.coin_pc
		_wisdom_pc = _wisdom_pc + tile.wisdom_pc
		_info_pc  = _info_pc + tile.info_pc
		_faith_pc = _faith_pc + tile.faith_pc
		//System.print("end") 
	}
	updatePcdata() {
		clearpcdata() 
		eachTile(Fn.new { |tile|
			tile.updatePcdata()
		})
		//System.print("gather")
		var city = this
		eachTile(Fn.new { |tile|
			city.gatherTilePcdata(tile)
		})
		//System.print("gathered")
	}
	inittile() {
		tiles.add(Tile.new(TILE_PLANE,TILE_PALACE))
		var i = 1
		while (i < 25) {
			tiles.add(Tile.new(TILE_NONE, TILE_NONE))
			i=i+1
		}
	}
	autoAssignToTile() {
		var pop = _pop.current
		var max = _pop.max
		var i = 0
		while (i < pop) {
			_tiles[i].assigned = 1
			i = i + 1
		}
		while (i < max) {
			_tiles[i].assigned = 0
			i = i + 1
		}
	}
	tiles { _tiles }
	addItem(item) {
		if (_items[item.subtype]!=null) {
			_items[item.subtype]=item
		} else {
			send("warning: already item is registered")
		}	
	}
	execEffectDataOngain(effectdata, item) {
				    // this city
	   _cv.doEffectOngain(effectdata, item, this)			    				 
	}
	gainItem(item) {
		if (this != item.city) {
			        System.printAll(["gainItem different city ", item.toString()])
		}
	        System.printAll(["gainItem ", item.toString()])
		if (_items[item.subtype]!=null) {
			_items[item.subtype]=item
			item.count = item.count + 1
			send("warning: gainitem: already item is registered")
			S.log([{"count":item.count}])
		} else {
			_items[item.subtype] = item
			item.count = 1
//		        var storeditem = _items[item.subtype]
//			storeditem.count = storeditem.count + 1
			S.log([{"count":item.count}])
		}
		var cond = cv.cm.conditions[item.subtype]
		execEffectDataOngain(cond.effectdata, item)	
		item.fire("ongain")
		send(["gainitem:", cv.cm.conditionname[item.subtype] ].join(" "))

		var n = []
		for (k in _items.keys) {
		    n.add(k)
		}

		System.printAll(["zzzz", n])
		displayItems()
		for (k in _items.keys) {
		    System.print(["xxxxx", _items[k]])
		}
	}
	produce_resource() {
//		System.print("produce resource")
		_pan = _pan + _pan_pc
		_hammer = _hammer + _hammer_pc
		_coin = _coin + _coin_pc
		_wisdom = _wisdom + _wisdom_pc
		_info = _info + _info_pc
		_faith = _faith + _faith_pc
	}
	changePercent(m,r,c) {
		_m_percent = m
		_r_percent = r
		_c_percent = c
	}
	apply_itemeffect_onturn() {
		gatherPerturnEffect()
		_food = _food + _perturn_addop[EF_ADD_FOOD]
		_money = _money + _perturn_addop[EF_ADD_MONEY]
		_beaker = _beaker + _perturn_addop[EF_ADD_BEAKER]
		_gear = _gear + _perturn_addop[EF_ADD_GEAR]
		_art = _art + _perturn_addop[EF_ADD_ART]
		_symbol = _symbol + _perturn_addop[EF_ADD_SYMBOL]
		_food = _food * _perturn_multop[EF_MULT_FOOD]/100
		_money = _money * _perturn_multop[EF_MULT_MONEY]/100
		_beaker = _beaker * _perturn_multop[EF_MULT_BEAKER]/100
		_gear = _gear * _perturn_multop[EF_MULT_GEAR]/100
		_art = _art * _perturn_multop[EF_MULT_ART]/100
		_symbol = _symbol * _perturn_multop[EF_MULT_SYMBOL]/100
		for (k in _items.keys) {
			var item = _items[k]
			item.fire("perturnplus")
		}
	}
	displayStat(ph) {
		System.printAll([{"city":name},{"ph":ph},{"pop":_pop.current},{"food":_food},{"money": _money},{"beaker": _beaker},{"gear": _gear},{"art": _art},{"symbol": _symbol}])		
	}
	divide_resource() {
		_money = _coin * _m_percent
		_beaker = _coin * _r_percent
		_art = _coin * _c_percent
		_food = _pan
		_gear =		_hammer
		_symbol = _faith
		_art = _art + _wisdom

		_pan = 0
		_hammer = 0
		_coin = 0
		_wisdom = 0
		_info = 0
		_faith = 0
	}
	displayPerturnOp() {
		System.printAll([{"op":"add"}, [_perturn_addop[EF_ADD_FOOD],		_perturn_addop[EF_ADD_MONEY],		_perturn_addop[EF_ADD_BEAKER],		_perturn_addop[EF_ADD_GEAR],		_perturn_addop[EF_ADD_ART],	_perturn_addop[EF_ADD_SYMBOL]]])
		System.printAll([{"op":"mult"}, [		_perturn_multop[EF_MULT_FOOD],		_perturn_multop[EF_MULT_MONEY],		_perturn_multop[EF_MULT_BEAKER],		_perturn_multop[EF_MULT_GEAR],		_perturn_multop[EF_MULT_ART],		_perturn_multop[EF_MULT_SYMBOL]] ])
	}
	display() {
		System.printAll([{"city":name}])
		System.printAll([{"city":name},{"pop": _pop.current}, {"limit": _pop.limit},{"max": _pop.max}] )
		System.printAll([{"city":name},{"pan":_pan},{"hammer":_hammer },{"coin":_coin },{"wisdom":_wisdom},{"info":_info},{"faith":_faith}])
		System.printAll([{"city":name},{"panpc":_pan_pc},{"hammerpc":_hammer_pc},{"coinpc":_coin_pc},{"wisdompc":_wisdom_pc},{"infopc":_info_pc},{"faithpc":_faith_pc}])
		System.printAll([{"city":name},{"food":_food},{"money": _money},{"beaker": _beaker},{"gear": _gear},{"art": _art},{"symbol": _symbol}])
		System.printAll([{"city":name},{"foodstock":_foodstock},{"_granary":_granary}])
		var i = 0
		System.write("tile:")
		while (i < _tiles.count) {
			var tile = _tiles[i]
			if (tile.assigned == 1) {
				tile.display()
				System.printAll([{"assigned":tile.assigned, "terrain": tile.terrain}])	
			}
			i = i+1
		}
		if (producting != null) {
			System.printAll([{"city":name},{"producting": producting.subtype}, {"name":cv.cm.conditionname[producting.subtype]}, {"money": producting.money}, {"gear": producting.gear},{"c":producting.count}])
			var reqs = cv.cm.postpay[producting.subtype]
			var i = 0
			while (i < reqs.count) {
				System.printAll([{"subtype":reqs[i].subtype, "count":reqs[i].count}])
				i = i + 1
			}
		} else {
				System.print("produting no")
		}
		displayPerturnOp()
	}
	displayItems() {
		System.print("display items")
		for (k in _items.keys) {
		    System.print(["display items", k, cv.cm.conditionname[k], _items[k]])
		}
	}
	onclick() {
                        this.produce_resource()				
	}
	onturn() {
                this.divide_resource()
		displayStat("divided")
		this.apply_itemeffect_onturn()
		displayPerturnOp()
		displayStat("itemeffected")		
		this.calculate_cost_onturn()
		displayStat("cost calculated")				
		this.growth()
		displayStat("grown")
	}
	growth() {
		_foodstock = _foodstock + _food
		if (own(BV C_BUILDING_GRANARY)) {
			_granary = _granary + _food
		}
		if (_foodstock > _pop.current*3+30 && _pop.current < _pop.limit)  {
		   _pop.add(1)
		   autoAssignToTile()
		   _foodstock = _foodstock - (_pop.current*3+30)
		}
		if (_foodstock < 0) {
		   if (_pop.current > 1) {
		    	_pop.add(-1)
		   	autoAssignToTile()
	    	   }
		}
		autoAssignToTile()
		_food = 0
	}
	calculate_cost_onturn() {
		System.print("city#calculate_cost_onturn()")
		_food = _food - _pop.current
		if (_producting != null) {
			var req = cv.cm.postpay[_producting.subtype]	
			_producting.req = req
			var i = 0
			var ok = 0
			while (i < req.count) {
				var r = req[i]
				if (r.subtype == C_MONEY) {
					_producting.money = _producting.money + _money
					var v = _producting.money - r.count
					if (v >= 0) {
						_money = v
					 	_producting.money = _producting.money - v
						ok = ok + 1
					}
				}
				if (r.subtype == C_GEAR) {
					_producting.gear = _producting.gear + _gear
					var v = _producting.gear - r.count
					if (v >= 0) {
						_gear = v
					 	_producting.gear = _producting.gear - v
						ok = ok + 1
					}
				}
				if (r.subtype == C_BEAKER) {
					_producting.beaker = _producting.beaker + _beaker
					var v = _producting.beaker - r.count
					if (v >= 0) {
						_beaker = v
					 	_producting.beaker = _producting.beaker - v
						ok = ok + 1
					}
				}
				i = i + 1
			}
			if (ok == req.count) {
				var product = producting
				_producting = null
				gainItem(product)
			}
		}
	}
	own(t) {
		return 0
	}
	eachTile(func) {
		var i = 0
		while (i < _tiles.count) {
			var c = _tiles[i]
                        func.call(c)
			i = i+1
		}
	}
	pop { _pop }
	food{_food}
	money{_money}
	beaker{_beaker}
	gear{_gear}
	art{_art}
	symbol{_symbol}
	clearOutcome() {
		_food = 0
		_money = 0
		_beaker = 0
		_gear = 0
		_art = 0
		_symbol = 0
	}
	getpc() {
		return [_pan_pc,_hammer_pc,_coin_pc,_wisdom_pc,_info_pc,_faith_pc]
	}
	buildStartBySubtype(name) {
		if (_producting != null) {
			send(["error: already product"])
			return 0
		} 
		var st = cv.findBuildingBySubtype(name)
		if (st != null) {
			if (_items[name]) {
				var item = _items[st]
				if (item.count > 0) {
					send(["error: already have product ", name, " ", st])
					return -1
				}
			}
			send(["product start ", st.name])
			_producting = Item.new(this, cv, st.subtype, 0)
			return 0
		} else {
			send(["error: unknown product ", name, " ", st])
			return -2
		}
	}

	send(s) {
		System.write("send: ")
		System.printAll(s)
	}
	applyPerclickEffect(addop, multop) {
	}
	gatherPerClickEffect() {
	/*
		addop = {}
		multop = {}		
		var i = 0
		while (i < _items.count) {
		      var item = _items[i]
		      var cond = conditions[item.subtype]
     		      var effects = cond.effects["perclick"]
		      var j = 0
		      while (j < effects) {
		      	    var effect = effects[j]
 		            if (effect.op == EF_ADD) {
			       	  addop[effect.etype] = addop[effect.etype] + effect.count
			    }
			    if (effect.op == EF_MULT) {
			   	  multop[effect.etype] = addop[effect.etype] + effect.count
			    }
		      	    j=j+1
		      }
		      i = i + 1
		}
		*/
	}
	gatherPerturnEffect() {
	        System.printAll(["gathereffect ", _items.keys.count, " ", _items])	
//	        System.print(["gathereffect", _items.keys.count])
		if (0) {
		var i = 0
		_perturn_addop = {}
		_perturn_addop[EF_ADD_FOOD]=0
		_perturn_addop[EF_ADD_MONEY]=0
		_perturn_addop[EF_ADD_BEAKER]=0
		_perturn_addop[EF_ADD_GEAR]=0
		_perturn_addop[EF_ADD_ART]=0
		_perturn_addop[EF_ADD_SYMBOL]=0
		_perturn_multop = {}		
		_perturn_multop[EF_MULT_FOOD]=100
		_perturn_multop[EF_MULT_MONEY]=100
		_perturn_multop[EF_MULT_BEAKER]=100
		_perturn_multop[EF_MULT_GEAR]=100
		_perturn_multop[EF_MULT_ART]=100
		_perturn_multop[EF_MULT_SYMBOL]=100
		for (k in _items.keys) {
		      var item = _items[k]
		      var cond = cv.cm.conditions[item.subtype]
//		      var effects = cond.effects["perturn"]
//		      var name = cv.cm.conditionname[item.subtype]
//		      System.printAll(["xxxx", name, effects])
/*
		      var j = 0
		      while (j < effects.count) {
		      	    var effect = effects[j]
		            if (effect.op == EF_ADD) {
			       	  _perturn_addop[effect.etype] = _perturn_addop[effect.etype] + effect.count
 		            }
 			    if (effect.op == EF_MULT) {
			       	  _perturn_multop[effect.etype] = _perturn_multop[effect.etype] + effect.count
			    }
		      	    j=j+1
		      }
		      i = i + 1
		      */
		}
//		System.print(["#####",_perturn_addop[EF_SYMBOL]])
//		System.print(["#####",_perturn_multop[EF_SYMBOL]])
		}
	}
	cityid{_cityid}
	cvid{_cvid}	
}

var cv = CV.new("abc","def")

System.print(cv.getPrereqOf(TV C_TECH_MASONRY))

cv.addCity(City.new(cv,"abc"))
cv.updatePcdata()

class World {
      construct new() {
      		_cv = {}
		_city = {}
		_cvidseed = 0
		_cityidseed = 0
		_currentcvid = 0
      }
      addCv(cv) {
      		cv.cvid=_cvidseed
      		_cv[cv.cvid] = cv
		_cvidseed=_cvidseed+1
      }
      addCity(city) {
		city.cityid=_cityidseed
     		_city[city.cityid] =city
		_cityidseed=_cityidseed+1		
      }
	nextclick(num) {
		  for (id in _cv.keys) {_cv[id].nextclick(1) }
	}
	nextturn(num) {
		  for (id in _cv.keys) {_cv[id].nextturn(1) }	
	}
	display() {
		  for (id in _cv.keys) {_cv[id].display() }		

	}
	cv {_cv}
	city {_city}
	currentcv {
		  return _cv[_currentcvid]
        }
}

class Run {
	construct new(game) {
		_game = game
	}
	onclick() {
//		System.print("run#onclick")
		game.nextclick(1)
	}
	onturn() {
//		System.print("run#onturn")
		game.nextturn(1)
	}
	display() {
//		System.print("run#display")
		game.display()

	}
	game {_game}
	cv {
	   return _game.currentcv
	}	
}


var game=World.new()
game.addCv(cv)
var runner = Run.new(game)


import "io" for Stdin

//var x = Stdin.readLine()


System.print(cv.name)
//System.print(x)
while (true) {
System.print("prompt")
var line = Stdin.readLine()
var args = line.split(" ")
if (args[0] == "T") {
	System.print("add")
	cv.addFood(100) 
	cv.addMoney(200)
	cv.addBeaker(300) 
	cv.addArt(400) 
	cv.addHammer(300) 

}
if (args[0] == "c") {
	if (args.count >= 2) {
		var count = Num.fromString(args[1])
		var i = 0
		while (i < count) {
			runner.onclick()
			i = i + 1
		}
	} else {
		runner.onclick()
	}
}
if (args[0] == "t") {
	runner.onturn()
} else if (args[0] == "ct") {
   	var count = 10
	if (args.count >= 2) {
		var count = Num.fromString(args[1])
	}
		var i = 0
		while (i < count) {
			runner.onclick()
			i = i + 1
		}
		runner.onturn()			
} else if (args[0] == "d") {
	runner.display()
} else if (args[0] == "establish") {
	if (args[1] == "city") {
		var c = City.new(cv,args[2])
		runner.cv.addCity(c)
	}
} else if (args[0] == "b") {
		var c = null
		if (args.count <= 2) {
			c = runner.cv.capital
		} else {
			c = runner.cv.findCityByName(args[2])
		if (c == null) {
			c = runner.cv.capital
		}
		}
		System.printAll([">build ", args[1]])
		runner.cv.buildStartByName(c, args[1])
} else if (args[0] == "gain") {
	if (args.count >= 2) {
	   	       var c =	   	       Cstr.new()
			var count = Num.fromString(args[1])
   	       System.printAll(["gain ", c.debugi[count]])			
		var product = Item.new(cv.capital, cv, count, 0)
		cv.capital.gainItem(product)		
	} else {
	
	}
} else {
  System.print("unknown command")
}

}
System.print("end")


