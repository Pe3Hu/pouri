extends MarginContainer


@onready var core = $HBox/VBox/HBox/Core
@onready var tally = $HBox/VBox/Tally
@onready var indicators = $HBox/VBox/HBox/Indicators
@onready var abilities = $HBox/Abilities

var tribe = null


func set_attributes(input_: Dictionary) -> void:
	tribe = input_.tribe
	
	var input = {}
	input.creature = self
	tally.set_attributes(input)
	core.set_attributes(input)
	indicators.set_attributes(input)
	abilities.set_attributes(input)


func knockout() -> void:
	pass
