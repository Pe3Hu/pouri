extends MarginContainer


@onready var creatures = $HBox/Creatures
@onready var infirmary = $HBox/Infirmary

var tribe = null
var opponent = null
var battleground = null
var winner = null


func set_attributes(input_: Dictionary) -> void:
	tribe = input_.tribe
	
	for creature in input_.creatures:
		creatures.add_child(creature)
		creature.troop = self
		creature.reset_rating()


func get_ranking(type_: String, subtype_: String) -> Array:
	var ranking = []
	
	if creatures.get_child_count() > 0:
		ranking.append_array(creatures.get_children())
		ranking.sort_custom(func(a, b): return a.rating[type_][subtype_] < b.rating[type_][subtype_])
	
	return ranking
