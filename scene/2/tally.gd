extends MarginContainer


@onready var parameters = $Parameters

var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	init_parameters()


func init_parameters() -> void:
	var input = {}
	input.tally = self
	
	for index in Global.dict.parameter.index:
		var description = Global.dict.parameter.index[index]
		input.type = description.type
		input.subtype = description.subtype
	
		var parameter = Global.scene.parameter.instantiate()
		parameters.add_child(parameter)
		parameter.set_attributes(input)
