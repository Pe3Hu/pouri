extends MarginContainer


@onready var bars = $VBox/Bars
@onready var health = $VBox/Bars/Health
@onready var barrier = $VBox/Bars/Barrier
@onready var energy = $VBox/Bars/Energy

var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	init_bars()


func init_bars() -> void:
	var input = {}
	input.indicators = self
	
	for type in Global.arr.indicator:
		var indicator = get(type)
		input.type = type
		var parameter = creature.tally.get_parameter(type, "limit")
		input.max = parameter.value.get_number()
		
		if type == "energy":
			input.type = Global.dict.energy.type[creature.core.primary]
		
		indicator.set_attributes(input)


func get_indicator(type_: String) -> Variant:
	for indicator in bars.get_children():
		if indicator.name.to_lower() == type_:
			return indicator
	
	return null
