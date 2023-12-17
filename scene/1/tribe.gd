extends MarginContainer


@onready var creatures = $Creatures

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_creatures()


func init_creatures() -> void:
	for _i in 3:
		var input = {}
		input.tribe = self
	
		var creature = Global.scene.creature.instantiate()
		creatures.add_child(creature)
		creature.set_attributes(input)


func get_creatures_for_troop() -> Array:
	var n = 5
	n = min(n, creatures.get_child_count())
	
	var _creatures = []
	
	for _i in n:
		var creature = creatures.get_child(0)
		creatures.remove_child(creature)
		_creatures.append(creature)
	
	return _creatures
	
