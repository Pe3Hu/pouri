extends MarginContainer


@onready var ornaments = $Ornaments

var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature

