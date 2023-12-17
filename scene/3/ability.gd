extends MarginContainer


@onready var priorityExtreme = $HBox/Priority/Extreme
@onready var priorityType = $HBox/Priority/Type
@onready var speedCast = $HBox/Speed/Cast
@onready var speedEcho = $HBox/Speed/Echo
@onready var damageMin = $HBox/Damage/Min
@onready var damageMax = $HBox/Damage/Max
@onready var energyChange = $HBox/Energy/Change
@onready var energyCooldown = $HBox/Energy/Cooldown

var abilities = null
var priority = null
var weight = null
var kind = null
var keyword = null
var cast = {}
var source = null
var echo = null
var damage = {}
var energy = null


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
	input.proprietor = self
	input.type = "priority"
	input.subtype = priority.extreme
	priorityExtreme.set_attributes(input)
	
	input.subtype = priority.type
	priorityType.set_attributes(input)
	
	input.type = "ability"
	input.subtype = "cast"
	input.value = cast.duration
	speedCast.set_attributes(input)
	
	input.subtype = "echo"
	input.value = echo
	speedEcho.set_attributes(input)
	
	input.subtype = "echo"
	input.value = 0
	damageMin.set_attributes(input)
	
	input.subtype = "echo"
	input.value = 0
	damageMax.set_attributes(input)
	update_damage()
	
	input.subtype = "energy"
	input.value = -energy
	energyChange.set_attributes(input)
	
	input.ability = self
	energyCooldown.set_attributes(input)


func update_damage() -> void:
	damage.base = weight
	
	if kind != "ultimate":
		damage.base = round(weight / (6 / cast.duration))
	
	var extremes = ["Min", "Max"]
	var scatter = Global.dict.keyword.title[keyword].scatter
	scatter = round(damage.base * scatter / 100.0)
	
	for extreme in extremes:
		var couple = get("damage" + extreme)
		var _sign = 1
		
		if extreme == "Min":
			_sign = -1
		
		var value = damage.base + scatter * _sign
		couple.stack.set_number(value)


func roll_damage() -> void:
	var extremes = ["Min", "Max"]
	var value = {}
	
	for extreme in extremes:
		var couple = get("damage" + extreme)
		value[extreme] = couple.stack.get_number()

	Global.rng.randomize()
	damage.roll = Global.rng.randi_range(value["Min"], value["Max"])


func energy_check() -> bool:
	var indicator = abilities.creature.indicators.get("energy")
	var value = {}
	value.current = indicator.get_value("current")
	value.limit = -energyChange.stack.get_number()
	return value.current >= value.limit


func trigger_check() -> bool:
	return false


func apply_effects() -> void:
	abilities.creature.update_target(self)
	
	for _i in echo:
		if abilities.creature.target != null:
			roll_damage()
			abilities.creature.rating.health.current += damage.roll
			abilities.creature.target.get_damage_from_ability(self)
			
			if kind == "ordinary":
				abilities.creature.change_energy(-energy)
