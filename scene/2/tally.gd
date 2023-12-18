extends MarginContainer


#@onready var parameters = $Parameters

var creature = null
var parameters = {}


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	init_parameters()


func init_parameters() -> void:
	for index in Global.dict.parameter.index:
		var description = Global.dict.parameter.index[index]
		
		if !parameters.has(description.type):
			parameters[description.type] = {}
		
		parameters[description.type][description.subtype] = description.value


func get_limit(type_: String) -> Variant:
	if parameters.has(type_):
		if parameters[type_].has("limit"):
			return parameters[type_]["limit"]
	
	return null


func get_regeneration(type_: String) -> Variant:
	if parameters.has(type_):
		if parameters[type_].has("regeneration"):
			return parameters[type_]["regeneration"]
	
	return null


func get_value_based_on_type_and_source(type_: String, source_: String) -> int:
	return parameters[type_][source_] + parameters[type_]["universal"]


func get_resistance_multiplier_based_on_source_and_penetration(source_: String, penetration_: int) -> float:
	var value = get_value_based_on_type_and_source("resistance", source_) - penetration_
	
	if value >= 0:
		return 100.0 / (100 + value)
	else:
		return 2 - 100.0 / (100 - value)


func get_tempo_multiplier_based_on_source(source_: String) -> float:
	var value = get_value_based_on_type_and_source("tempo", source_)
	return 1 + value / 100.0


func get_specialization_multiplier(subtype_: String) -> float:
	var value = parameters.specialization[subtype_]
	return 1 + value / 100.0


func get_block_based_on_type_and_source(type_: String, source_: String) -> int:
	var block = 0
	
	if trigger_probability_check(type_, source_):
		block = parameters[type_]["limit"]
	
	return block


func trigger_probability_check(type_: String, source_: String) -> bool:
	var chance = get_value_based_on_type_and_source(type_, source_) / 100.0
	
	Global.rng.randomize()
	var random = Global.rng.randf_range(0, 1)
	return chance >= random
