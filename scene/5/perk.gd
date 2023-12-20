extends MarginContainer


@onready var type = $HBox/Type
@onready var subtype = $HBox/Subtype
@onready var value = $HBox/Value

var proprietor = null
var particle = null


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	if input_.has("particle"):
		particle = input_.particle
	
	roll()


func roll() -> void:
	var key = "common"
	
	if particle != null:
		key = particle
	
	var index = Global.get_random_key(Global.dict.parameter.rarity[key])
	var description = Global.dict.parameter.index[index]
	
	var n = 5
	Global.rng.randomize()
	var rank = Global.rng.randi_range(0, n - 1)
	var step = float(description.max - description.min) / n
	
	var input = {}
	input.type = "parameter"
	input.subtype = description.type
	type.set_attributes(input)
	type.custom_minimum_size = Vector2(Global.vec.size.particle)
	
	input.type = "parameter"
	input.subtype = description.subtype
	subtype.set_attributes(input)
	subtype.custom_minimum_size = Vector2(Global.vec.size.particle)
	
	input.type = "number"
	input.subtype = description.min + rank * step
	value.set_attributes(input)
	value.custom_minimum_size = Vector2(Global.vec.size.particle)


func apply() -> void:
	var bonus = {}
	bonus.type = type.subtype
	bonus.subtype = subtype.subtype
	bonus.value = value.get_number()
	proprietor.creature.tally.apply_bonus(bonus)
