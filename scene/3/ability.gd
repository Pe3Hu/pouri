extends MarginContainer


@onready var priorityExtreme = $HBox/Priority/Extreme
@onready var priorityType = $HBox/Priority/Type
@onready var tempoCast = $HBox/Tempo/Cast
@onready var tempoEcho = $HBox/Tempo/Echo
@onready var chargeMin = $HBox/Сharge/Min
@onready var chargeMax = $HBox/Сharge/Max
@onready var energyChange = $HBox/Energy/Change
@onready var energyCooldown = $HBox/Energy/Cooldown
@onready var conditionCurrent = $HBox/Condition/Current
@onready var conditionMax = $HBox/Condition/Max
@onready var conditionBox = $HBox/Condition
@onready var energyBox = $HBox/Energy

var abilities = null
var priority = null
var weight = null
var kind = null
var keyword = null
var cast = {}
var source = null
var echo = null
var charge = {}
var energy = null
var condition = {}
var trophies = []


func set_attributes(input_: Dictionary) -> void:
	if input_.has("energy"):
		weight = Global.num.weight.energy * input_.energy
	else:
		weight = Global.num.weight[input_.kind]
		input_.energy = 0
		
		if input_.kind == "ordinary":
			input_.energy = -Global.dict.cast.energy[input_.cast.type][input_.cast.subtype][input_.source]
	
	for key in input_:
		set(key, input_[key])
		
	cast.duration = 0
	
	if kind != "ultimate":
		cast.duration = Global.dict.cast.duration[cast.type][cast.subtype]
	
	init_icons()


func init_icons() -> void:
	var input = {}
	input.ability = self
	energyCooldown.set_attributes(input)
	
	input.proprietor = self
	input.type = "priority"
	input.subtype = priority.extreme
	priorityExtreme.set_attributes(input)
	
	input.subtype = priority.type
	priorityType.set_attributes(input)
	
	input.type = "ability"
	input.subtype = "cast"
	input.value = 0
	tempoCast.set_attributes(input)
	update_tempo()
	
	input.subtype = "echo"
	input.value = echo
	tempoEcho.set_attributes(input)
	
	input.subtype = "min"
	input.value = 0
	chargeMin.set_attributes(input)
	
	input.subtype = "max"
	input.value = 0
	chargeMax.set_attributes(input)
	update_charge()
	
	if kind != "ultimate":
		conditionBox.visible = false
		
		input.subtype = "energy"
		input.value = -energy
		energyChange.set_attributes(input)
	else:
		set_condition()
		energyBox.visible = false
		
		input.type = "parameter"
		input.subtype = condition.subtype
		input.value = 0
		conditionCurrent.set_attributes(input)
		
		input.value = condition.value
		conditionMax.set_attributes(input)


func set_condition() -> void:
	var core = abilities.creature.core
	
	for index in Global.dict.ultimate.index:
		var description = Global.dict.ultimate.index[index]
		
		if description.particle.primary == core.primary and description.particle.secondary == core.secondary:
			condition = Dictionary(description.condition)
			condition.index = index
			#condition.type = description.condition.type
			#condition.subtype = description.condition.subtype
			#condition.value = description.condition.value


func update_charge() -> void:
	charge.base = weight
	var tally = abilities.creature.tally
	
	if kind != "ultimate":
		charge.base = snapped(weight / (6 / cast.duration) * tally.get_specialization_multiplier("base"), 0.1)
	
	var extremes = ["min", "max"]
	var scatter = Global.dict.keyword.title[keyword].scatter
	scatter = snapped(charge.base * scatter / 100.0, 0.1)
	
	for extreme in extremes:
		var couple = get("charge" + extreme.capitalize())
		var _sign = 1
		
		if extreme == "min":
			_sign = -1
		
		charge[extreme] = charge.base + scatter * _sign
		charge[extreme] = snapped(charge[extreme] * tally.get_specialization_multiplier(extreme), 0.1)
		couple.stack.set_number(charge[extreme])


func update_tempo() -> void:
	if kind != "ultimate":
		var multiplier = abilities.creature.tally.get_tempo_multiplier_based_on_source(source)
		var value = float(cast.duration) / multiplier
		tempoCast.stack.set_number(value)
		energyCooldown.update_duration()


func roll_charge() -> void:
	var extremes = ["Min", "Max"]
	var value = {}
	
	for extreme in extremes:
		var couple = get("charge" + extreme)
		value[extreme] = couple.stack.get_number()

	Global.rng.randomize()
	charge.roll = Global.rng.randf_range(value["Min"], value["Max"])
	charge.trigger = {}
	
	for type in Global.arr.offense:
		if abilities.creature.tally.trigger_probability_check(type, source):
			charge.trigger[type] = abilities.creature.tally.get_offense_multiplier(type)
			
			if type != "lifesteal":
				var conditions = {}
				conditions.type = "triggered"
				conditions.subtype = type
				conditions.value = round(charge.roll * charge.trigger[type])
				abilities.trigger_ultimate_conditions_check(conditions)


func energy_check() -> bool:
	var indicator = abilities.creature.indicators.get("energy")
	var value = {}
	value.current = indicator.get_value("current")
	value.limit = -energyChange.stack.get_number()
	return value.current >= value.limit


func trigger_check() -> bool:
	return conditionCurrent.stack.get_number() >= conditionMax.stack.get_number()


func apply_effects() -> void:
	abilities.creature.update_target(self)
	
	for _i in echo:
		if abilities.creature.target != null:
			roll_charge()
			
			var conditions = {}
			conditions.type = "performed"
			conditions.subtype = "gesture"
			conditions.value = energy
			abilities.trigger_ultimate_conditions_check(conditions)
			abilities.creature.target.get_damage_from_ability(self)
			
			if kind == "ordinary":
				abilities.creature.change_energy(-energy)


func change_conditions(value_: int) -> void:
	conditionCurrent.change_number(value_)
