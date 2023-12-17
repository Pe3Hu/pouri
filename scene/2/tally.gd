extends MarginContainer


@onready var parameters = $Parameters

var creature = null
var resistance = {}


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	init_parameters()
	
	for source in Global.arr.source:
		update_resistance(source)


func init_parameters() -> void:
	var input = {}
	input.tally = self
	
	for index in Global.dict.parameter.index:
		var description = Global.dict.parameter.index[index]
		input.type = description.type
		input.subtype = description.subtype
		input.value = description.value
	
		var parameter = Global.scene.parameter.instantiate()
		parameters.add_child(parameter)
		parameter.set_attributes(input)


func get_parameter(type_: String, subtype_: String) -> Variant:
	for parameter in parameters.get_children():
		if parameter.type.subtype == type_ and parameter.subtype.subtype == subtype_:
			return parameter
	
	return null


func update_resistance(source_: String) -> void:
	var parameter = get_parameter("resistance", source_)
	var value = parameter.value.get_number()
	
	if value >= 0:
		resistance[source_] = 100 / (100 + value)
	else:
		resistance[source_] = 2 - 100 / (100 - value)
