extends MarginContainer


var mainland = null
var grid = null
var tribes = []


func set_attributes(input_: Dictionary) -> void:
	mainland = input_.mainland
	grid = input_.grid
	
	custom_minimum_size = Global.vec.size.land


func add_tribe(tribe_: MarginContainer) -> void:
	tribes.append(tribe_)
	
	if tribes.size() == 2:
		init_battleground()


func init_battleground() -> void:
	var input = {}
	input.land = self
	
	var battleground = Global.scene.battleground.instantiate()
	mainland.battlegrounds.add_child(battleground)
	battleground.set_attributes(input)
	
	for tribe in tribes:
		input.tribe = self
		input.creatures = tribe.get_creatures_for_troop()
		
		var troop = Global.scene.troop.instantiate()
		battleground.add_troop(troop)
		troop.set_attributes(input)
	
	battleground.start()
	
