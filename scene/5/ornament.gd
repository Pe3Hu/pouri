extends MarginContainer


@onready var order = $VBox/Order
@onready var perks = $VBox/Perks

var battleground = null


func set_attributes(input_: Dictionary) -> void:
	battleground = input_.battleground
	
	var input = {}
	input.type = "number"
	input.subtype = input_.order
	order.set_attributes(input)
	order.custom_minimum_size = Vector2(Global.vec.size.particle)
	
	init_perks()


func init_perks() -> void:
	var description = Global.dict.ornament[order.get_number()]
	
	for particle in description:
		for _i in description[particle]:
			var input = {}
			input.ornament = self
			input.particle = particle 
			
			var perk = Global.scene.perk.instantiate()
			perks.add_child(perk)
			perk.set_attributes(input)
