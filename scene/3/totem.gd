extends MarginContainer


var creature = null
var index = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature


func set_index() -> void:
	for _index in Global.dict.totem.index:
		if Global.dict.totem.index[_index].aspect.primary == creature.core.primary:
			index = _index
			return


func apply_bonuses(type_: String, value_: int) -> void:
	var coefficient = Global.num.aspect[type_]
	var description = Global.dict.totem.index[index]
	
	for letter in description.bonus:
		var value = snappedf(value_ * coefficient * description.bonus[letter].multiplier, 0.01)
		creature.tally.parameters[description.bonus[letter].type][description.bonus[letter].subtype] += value
		
		if description.bonus[letter].subtype == "limit" and Global.arr.indicator.has(description.bonus[letter].type):
			var indicator = creature.indicators.get_indicator(description.bonus[letter].type)
			indicator.change_value("maximum", value)
		
		if description.bonus[letter].subtype == "specialization":
			for ability in creature.abilities.get_children():
				ability.update_damage()
		
		if description.bonus[letter].subtype == "tempo":
			for ability in creature.abilities.get_children():
				ability.update_tempo()
