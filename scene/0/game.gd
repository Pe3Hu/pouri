extends Node


@onready var sketch = $Sketch


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description snapped(value, 0.01)
	Global.rng.randomize()
	var rnd = Global.rng.randi_range(0, 1)
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					var creature = sketch.cradle.tribes.get_child(0).creatures.get_child(0)
					creature.select_ability()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
