extends MarginContainer


@onready var bg = $BG
@onready var value = $HBox/Value

var core = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	core = input_.core
	type = input_.type
	
	var style = StyleBoxFlat.new()
	style.bg_color = Global.color.particle[type]
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = input_.value
	value.set_attributes(input)
	if type != "level":
		value.custom_minimum_size = Vector2(Global.vec.size.particle)
	else:
		value.custom_minimum_size = Vector2(Global.vec.size.particle * 0.5)
