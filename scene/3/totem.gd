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
		var bonus = {}
		bonus.type = description.bonus[letter].type
		bonus.subtype = description.bonus[letter].subtype
		bonus.value = snappedf(value_ * coefficient * description.bonus[letter].multiplier, 0.01)
		creature.tally.apply_bonus(bonus)
