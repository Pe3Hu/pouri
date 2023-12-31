extends MarginContainer


@onready var value = $Value
@onready var bar = $ProgressBar

var indicators = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	indicators = input_.indicators
	type = input_.type
	
	set_value("maximum", input_.max)
	reset()
	update_color()
	custom_minimum_size = Global.vec.size.bar


func reset() -> void:
	match type:
		"health":
			set_value("current", bar.max_value)
		"barrier":
			set_value("current", bar.max_value * 0.25)
		"mana":
			set_value("current", bar.max_value * 0.5)
		"fury":
			set_value("current", 0)


func update_color() -> void:
	var keys = ["fill", "background"]
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.indicator[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)


func change_value(limit_: String, value_: float) -> void:
	value_ = round(value_)
	var conditions = {}
	conditions.type = "wasted"
	conditions.subtype = type
	conditions.value = value_
	
	match limit_:
		"current":
			bar.value += value_
			
			if bar.value >= bar.max_value:
				if type == "experience":
					indicators.update_experience()
				else:
					bar.value = bar.max_value
			
			if bar.value < bar.min_value:
				match type:
					"barrier":
						indicators.health.change_value("current", bar.value)
					"health":
						indicators.creature.set_as_knockouted()
				
				conditions.value = bar.min_value - bar.value
				bar.value = bar.min_value
			
			indicators.creature.abilities.trigger_ultimate_conditions_check(conditions)
			value.text = str(bar.value)
		"maximum":
			bar.max_value += value_


func set_value(limit_: String, value_: float) -> void:
	value_ = round(value_)
	
	match limit_:
		"current":
			bar.value = value_
			value.text = str(bar.value)
			
			if type == "health" and value_ == 0:
				indicators.creature.set_as_knockouted()
		"maximum":
			bar.max_value = value_
			var _value = min(bar.value, bar.max_value)
			set_value("current", _value)


func get_value(limit_: String) -> int:
	var _value = null
	
	match limit_:
		"current":
			_value = bar.value
		"maximum":
			_value = bar.max_value
	
	return _value


func get_percentage() -> int:
	return floor(bar.value * 100 / bar.max_value)
