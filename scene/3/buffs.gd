extends MarginContainer


@onready var temporary = $HBox/Temporary
@onready var permanent = $HBox/Permanent

var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature


