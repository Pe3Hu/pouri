extends MarginContainer


@onready var ordinary = $VBox/Ordinary
@onready var advanced = $VBox/Advanced
@onready var ultimate = $VBox/Ultimate

var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	roll_abilities()


func roll_abilities() -> void:
	var input = {}
	input.abilities = self
	
	for kind in Global.arr.kind:
		var ability = get(kind)
		input.kind = kind
		input.cast = {}
		input.cast.type = Global.dict.cast.duration.keys().pick_random()
		input.cast.subtype = Global.dict.cast.duration[input.cast.type].keys().pick_random()
		input.source = Global.arr.source.pick_random()
		input.keyword = Global.dict.keyword.type[input.source].pick_random()
		var index = Global.dict.priority.index.keys().pick_random()
		input.priority = Global.dict.priority.index[index]
		input.echo = 1
		input.erase("energy")
		
		if kind == "advanced":
			input.energy = Global.arr.advanced.pick_random()
	
		ability.set_attributes(input)
