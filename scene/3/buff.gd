extends MarginContainer


@onready var bar = $TextureProgressBar

var ability = null
var tween = null


func set_attributes(input_: Dictionary) -> void:
	ability = input_.ability
	
	custom_minimum_size = Global.vec.size.couple


func update_duration() -> void:
	var value = ability.tempoCast.stack.get_number()
	
	if value > 0:
		bar.max_value = value
	else:
		bar.max_value = 0
		bar.visible = false


func start() -> void:
	tween = create_tween()
	tween.tween_property(bar, "value", bar.max_value, bar.max_value)
	tween.tween_callback(end)


func end() -> void:
	bar.value = 0
	
	if !ability.abilities.creature.knockout and !ability.abilities.creature.troop.winner:
		ability.apply_effects()
		ability.abilities.creature.select_ability()
