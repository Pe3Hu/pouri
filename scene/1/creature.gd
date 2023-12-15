extends MarginContainer


@onready var core = $VBox/Core
@onready var tally = $VBox/Tally

var tribe = null


func set_attributes(input_: Dictionary) -> void:
	tribe = input_.tribe
	
	var input = {}
	input.creature = self
	tally.set_attributes(input)
	core.set_attributes(input)
