extends VBoxContainer


var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	for _i in 4:
		add_perk()


func add_perk() -> void:
	var input = {}
	input.proprietor = self
	
	var perk = Global.scene.perk.instantiate()
	add_child(perk)
	perk.set_attributes(input)
	perk.apply()
