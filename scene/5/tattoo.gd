extends MarginContainer


@onready var ornaments = $VBox/Ornaments
@onready var icons = $VBox/Icons

var creature = null
var orders = []


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	orders.append_array(Global.dict.ornament.order.keys())
	icons.custom_minimum_size = Vector2(Global.vec.size.particle)


func add_ornament(ornament_: MarginContainer) -> void:
	if orders.has(ornament_.order.subtype):
		orders.erase(ornament_.order.subtype)
		ornaments.add_child(ornament_)
		ornament_.set_tattoo(self)
		add_icon(ornament_.order.subtype)


func add_icon(order_: int) -> void:
	var input = {}
	input.type = "ornament"
	input.subtype = order_
	var icon = Global.scene.icon.instantiate()
	icons.add_child(icon)
	icon.set_attributes(input)
	icon.custom_minimum_size = Vector2(Global.vec.size.particle)
