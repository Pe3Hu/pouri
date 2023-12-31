extends MarginContainer


@onready var particles = $Particles
@onready var strength = $Particles/Strength
@onready var dexterity = $Particles/Dexterity
@onready var intellect = $Particles/Intellect
@onready var will = $Particles/Will
@onready var level = $Level

var creature = null
var primary = null
var secondary = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	init_particles()


func init_particles() -> void:
	var input = {}
	input.core = self
	input.type = "level"
	input.value = 1
	level.set_attributes(input)
	var retained = int(Global.num.core.base)
	var options = {}
	
	for type in Global.arr.particle:
		input.type = type
		var _particle = get(type)
		input.value = Global.num.particle.min
		_particle.set_attributes(input)
		retained -= input.value
		options[type] = Global.num.particle.max - Global.num.particle.min
	
	while retained > 0:
		var type = options.keys().pick_random()
		Global.rng.randomize()
		var value = Global.rng.randi_range(1, options[type])
		value = min(value, retained)
		options[type] -= value
		retained -= value
		var _particle = get(type)
		_particle.value.change_number(value)
		
		if options[type] == 0:
			options.erase(type)
	
	var datas = []
	
	for type in Global.arr.particle:
		var data = {}
		data.particle = get(type)
		data.value = data.particle.value.get_number()
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.value > b.value)
	
	if datas[0].value == datas[1].value:
		options = [0, 1]
		var _i = options.pick_random()
		var _j = (_i + 1) % options.size()
		datas[_i].particle.value.change_number(1)
		datas[_j].particle.value.change_number(-1)
		datas[_i].value += 1
		datas[_j].value += -1
	
	datas.sort_custom(func(a, b): return a.value > b.value)
	
	if datas[1].value == datas[2].value:
		options = [1, 2]
		var _i = options.pick_random()
		var _j = (_i + 1) % options.size()
		datas[_i].particle.value.change_number(1)
		datas[_j].particle.value.change_number(-1)
		datas[_i].value += 1
		datas[_j].value += -1
	
	datas.sort_custom(func(a, b): return a.value > b.value)
	
	primary = datas[0].particle.type
	secondary = datas[1].particle.type
	creature.totem.set_index()
	
	for order in Global.arr.order:
		var type = get(order)
		var particle = get(type)
		var value = particle.value.get_number()
		creature.totem.apply_bonuses(order, value)


func get_experience_multiplier_based_on_level_difference(creature_: MarginContainer) -> float:
	var difference = level.value.get_number() - creature_.core.level.value.get_number()
	var multiplier = pow(abs(difference) + 10, 2) / 100
	
	if difference > 0:
		multiplier = 1 / multiplier
	
	return multiplier

