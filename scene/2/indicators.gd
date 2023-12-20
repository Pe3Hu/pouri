extends MarginContainer


@onready var bars = $VBox/Bars
@onready var health = $VBox/Bars/Health
@onready var barrier = $VBox/Bars/Barrier
@onready var energy = $VBox/Bars/Energy
@onready var experience = $VBox/Bars/Experience

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
		input.max = creature.tally.get_limit(type)
		
		if type == "energy":
			input.type = Global.dict.energy.type[creature.core.primary]
		
		indicator.set_attributes(input)
	
	input.type = "experience"
	input.max = 100
	experience.set_attributes(input)


func get_indicator(type_: String) -> Variant:
	for indicator in bars.get_children():
		if indicator.name.to_lower() == type_:
			return indicator
	
	return null


func update_experience() -> void:
	while experience.bar.value >= experience.bar.max_value:
		creature.core.level.value.change_number(1)
		experience.bar.value = max(0, experience.bar.value - experience.bar.max_value)
		experience.bar.max_value = pow(creature.core.level.value.get_number() + 9, 2)
		creature.perks.add_perk()


func get_current_experience() -> int:
	return experience.bar.value + Global.dict.experience.level[creature.core.level.value.get_number()]
