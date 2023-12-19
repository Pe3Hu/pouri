extends MarginContainer


@onready var core = $HBox/VBox/HBox/Core
@onready var tally = $HBox/Tally
@onready var indicators = $HBox/VBox/HBox/Indicators
@onready var abilities = $HBox/VBox/Abilities
@onready var tattoo = $HBox/Tattoo
@onready var totem = $HBox/Totem

var tribe = null
var troop = null
var target = null
var knockout = false
var rating = {}
var murderer = null


func set_attributes(input_: Dictionary) -> void:
	tribe = input_.tribe
	
	var input = {}
	input.creature = self
	tally.set_attributes(input)
	totem.set_attributes(input)
	core.set_attributes(input)
	indicators.set_attributes(input)
	abilities.set_attributes(input)
	tattoo.set_attributes(input)


func use_ability(kind_: String) -> void:
	var ability = abilities.get(kind_)
	var energy = ability.energyChange.stack.get_number()
	
	match kind_:
		"advanced":
			change_energy(energy)
			var conditions = {}
			conditions.type = "wasted"
			conditions.subtype = "energy"
			conditions.value = energy
			abilities.trigger_ultimate_conditions_check(conditions)
		"ultimate":
			var value = -ability.conditionMax.stack.get_number()
			ability.conditionCurrent.stack.change_number(value)
	
	ability.energyCooldown.start()


func get_damage_from_ability(ability_: MarginContainer) -> void:
	var indicator = indicators.get("barrier")
	var penetration = ability_.abilities.creature.tally.get_value_based_on_type_and_source("penetration", ability_.source)
	var multiplier = tally.get_resistance_multiplier_based_on_source_and_penetration(ability_.source, penetration) 
	var income = ability_.charge.roll
	
	for type in ability_.charge.trigger:
		if type != "lifesteal":
			income *= ability_.charge.trigger[type]
	
	income = -round(multiplier * income)
	var block = tally.get_block_based_on_type_and_source("dodge", ability_.source)
	income += income
	
	if income < 0:
		block = tally.get_block_based_on_type_and_source("armor", ability_.source)
		income += income
	
	if income < 0:
		indicator.change_value("current", income)
		ability_.abilities.creature.rating.damage.current -= income
		rating.health.current = indicators.get_indicator("health").get_value("current")
		
		var conditions = {}
		conditions.type = "performed"
		conditions.subtype = "wound"
		conditions.value = income
		ability_.abilities.trigger_ultimate_conditions_check(conditions)
		
		if ability_.charge.trigger.has("lifesteal"):
			conditions.type = "triggered"
			conditions.subtype = "lifesteal"
			conditions.value = income * ability_.charge.trigger["lifesteal"]
			ability_.abilities.trigger_ultimate_conditions_check(conditions)
	
	if penetration > 0:
		var origin = tally.get_resistance_multiplier_based_on_source_and_penetration(ability_.source, 0) 
		var conditions = {}
		conditions.type = "performed"
		conditions.subtype = "penetration"
		conditions.value = round((origin - multiplier) * ability_.charge.roll)
		ability_.abilities.trigger_ultimate_conditions_check(conditions)
	
	if multiplier > 0:
		var conditions = {}
		conditions.type = "performed"
		conditions.subtype = "resistance"
		conditions.value = round((1 - multiplier) * ability_.charge.roll)
		ability_.abilities.trigger_ultimate_conditions_check(conditions)
	
	if knockout:
		murderer = ability_.abilities.creature
		#ability_.abilities.creature.trophies.append(self)
		ability_.abilities.creature.target = null
		
		if troop.creatures.get_child_count() == 0:
			troop.winner = false
			troop.opponent.winner = true
			troop.battleground.loser = troop
			troop.battleground.winner = troop.opponent
			troop.battleground.winner_prize()


func change_energy(energy_: int) -> void:
	var indicator = indicators.get("energy")
	indicator.change_value("current", energy_)


func select_ability() -> void:
	var kind = null
	
	for _i in range(Global.arr.ability.size()-1, -1, -1):
		kind = Global.arr.ability[_i]
		var ability = abilities.get(kind)
		
		match kind:
			"advanced":
				if ability.energy_check():
					break
			"ultimate":
				if ability.trigger_check():
					break
	
	use_ability(kind)


func set_as_knockouted() -> void:
	if troop != null:
		knockout = true
		troop.creatures.remove_child(self)
		troop.infirmary.add_child(self)


func active_passive_regeneration() -> void:
	for type in Global.arr.indicator:
		var indicator = indicators.get_indicator(type)
		var value = tally.get_regeneration(type)
		indicator.change_value("current", value)


func reset_rating() -> void:
	rating.damage = {}
	rating.damage.current = 0
	#rating.damage.outcome = 0
	#rating.damage.income = 0
	rating.health = {}
	rating.health.current = indicators.get_indicator("health").get_value("current")


func update_target(ability_: MarginContainer) -> void:
	target = null
	var extreme = ability_.priorityExtreme.subtype
	var type = ability_.priorityType.subtype
	var subtype = "current"
	var ranking = troop.opponent.get_ranking(type, subtype)
	
	if !ranking.is_empty():
		match extreme:
			"min":
				target = ranking.front()
			"max":
				target = ranking.back()
