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
	input.subtype = 0
	#input.type = "particle"
	#input.subtype = type
	#input.value = 0
	value.set_attributes(input)
	value.custom_minimum_size = Vector2(Global.vec.size.particle)
	
