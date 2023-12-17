extends MarginContainer


@onready var bar = $TextureProgressBar
@onready var timer = $Timer

var ability = null
var tween = null


func set_attributes(input_: Dictionary) -> void:
	ability = input_.ability
	
	custom_minimum_size = Global.vec.size.couple
	update_cooldown()


func update_cooldown() -> void:
	var value = ability.speedCast.stack.get_number()
	set_max(value)


func set_max(max_: float) -> void:
	if max_ > 0:
		bar.max_value = max_
		timer.wait_time = max_
	else:
		bar.max_value = timer.wait_time
		bar.visible = false


func start() -> void:
	tween = create_tween()
	tween.tween_property(bar, "value", bar.max_value, timer.wait_time)
	tween.tween_callback(end)


func end() -> void:
	bar.value = 0
	
	if !ability.abilities.creature.knockout and !ability.abilities.creature.troop.winner:
		ability.apply_effects()
		ability.abilities.creature.select_ability()
