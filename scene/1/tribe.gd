extends MarginContainer


@onready var creatures = $Creatures

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_creatures()


func init_creatures() -> void:
	for _i in 1:
		var input = {}
		input.tribe = self
	
		var creature = Global.scene.creature.instantiate()
		creatures.add_child(creature)
		creature.set_attributes(input)
