extends MarginContainer


@onready var type = $Type
@onready var subtype = $Subtype
@onready var value = $Value

var tally = null


func set_attributes(input_: Dictionary) -> void:
	tally = input_.tally
	
	update_icons(input_)


func update_icons(input_: Dictionary) -> void:
	var types = ["type", "subtype"]
	
	for key in Global.arr.parameter:
		var input = {}
		input.type = "number"
		input.subtype = 0
		
		if types.has(key):
			input.type = "parameter"
			input.subtype = input_[key]
		
		var icon = get(key)
		icon.set_attributes(input)
		icon.custom_minimum_size = Vector2(Global.vec.size.sixteen*2)
	custom_minimum_size = Vector2(Global.vec.size.parameter)
