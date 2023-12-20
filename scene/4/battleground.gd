extends MarginContainer


@onready var troops = $HBox/Troops
@onready var ornaments = $HBox/Ornaments
@onready var timer = $Timer


var land = null
var left = null
var right = null
var winner = null
var loser = null


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
	#winner = left
	
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
	
	var experience = {}
	experience.total = 0
	var shares = 0
	var trophies = {}
	
	for creature in winner.creatures.get_children():
		shares += creature.core.level.value.get_number()
		trophies[creature] = 0
	
	for creature in loser.infirmary.get_children():
		experience.current = creature.indicators.get_current_experience() + 120
		experience.total += experience.current
		
		#lottery bounty
		var lucky = trophies.keys().pick_random()
		var multiplier = lucky.core.get_experience_multiplier_based_on_level_difference(creature)
		var share = float(experience.current) / 3 * multiplier
		trophies[lucky] += share
		#print(["lucky", share])
		
		#murder bounty
		if trophies.has(creature.murderer):
			multiplier = creature.murderer.core.get_experience_multiplier_based_on_level_difference(creature)
			share = float(experience.current) / 3 * multiplier
			trophies[creature.murderer] += share
			#print(["murder", share])
	
	#general bounty
	for creature in trophies:
		var share = float(experience.total) / 3 * creature.core.level.value.get_number() / shares
		trophies[creature] += share
		#print(["general", share])
		creature.indicators.experience.change_value("current", trophies[creature])
	
	roll_ornaments()


func roll_ornaments() -> void:
	for creature in winner.creatures.get_children():
		for _i in 2:
			var input = {}
			input.battleground = self
			input.order = Global.dict.ornament.order.keys().pick_random()
		
			var ornament = Global.scene.ornament.instantiate()
			ornaments.add_child(ornament)
			ornament.set_attributes(input)
			
			ornaments.remove_child(ornament)
			creature.tattoo.add_ornament(ornament)
