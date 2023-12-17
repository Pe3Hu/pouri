extends MarginContainer


@onready var troops = $Troops
@onready var timer = $Timer


var land = null
var left = null
var right = null
var winner = null


func set_attributes(input_: Dictionary) -> void:
	land = input_.land
	Engine.time_scale = 3


func add_troop(troop_: MarginContainer) -> void:
	troop_.battleground = self
	troops.add_child(troop_)
	
	if left == null:
		left = troop_
	else:
		right = troop_
		right.opponent = left
		left.opponent = right


func start() -> void:
	for troop in troops.get_children():
		for creature in troop.creatures.get_children():
			creature.select_ability()
	
	timer.start()


func _on_timer_timeout():
	for troop in troops.get_children():
		for creature in troop.creatures.get_children():
			creature.active_passive_regeneration()


func winner_prize() -> void:
	timer.stop()
	Engine.time_scale = 1
	pass
