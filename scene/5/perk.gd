extends MarginContainer


@onready var type = $HBox/Type
@onready var subtype = $HBox/Subtype
@onready var value = $HBox/Value

var ornament = null
var particle = null


func set_attributes(input_: Dictionary) -> void:
	ornament = input_.ornament
	particle = input_.particle
	
	roll()


func roll() -> void:
	var index = Global.get_random_key(Global.dict.perk.particle[particle])
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
	type.set_attributes(input)
	subtype.custom_minimum_size = Vector2(Global.vec.size.particle)
	
	input.type = "number"
	input.subtype = description.min + rank * step
	value.set_attributes(input)
	value.custom_minimum_size = Vector2(Global.vec.size.particle)
