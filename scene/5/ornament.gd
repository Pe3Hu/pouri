extends MarginContainer


@onready var order = $VBox/Order
@onready var perks = $VBox/Perks

var battleground = null
var tattoo = null
var creature = null


func set_attributes(input_: Dictionary) -> void:
	battleground = input_.battleground
	
	init_order(input_.order)
	init_perks()


func init_order(order_: int) -> void:
	var input = {}
	input.type = "ornament"
	input.subtype = order_
	order.set_attributes(input)
	order.custom_minimum_size = Vector2(Global.vec.size.particle)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Global.color.particle.level
	order.bg.set("theme_override_styles/panel", style)


func init_perks() -> void:
	var description = Global.dict.ornament.order[order.subtype]
	
	for particle in description:
		for _i in description[particle]:
			var input = {}
			input.proprietor = self
			input.particle = particle 
			
			var perk = Global.scene.perk.instantiate()
			perks.add_child(perk)
			perk.set_attributes(input)


func set_tattoo(tattoo_: MarginContainer) -> void:
	tattoo = tattoo_
	creature = tattoo.creature
	apply_perks()


func apply_perks() -> void:
	for perk in perks.get_children():
		perk.apply()
