extends MarginContainer


@onready var tribes = $Tribes

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_tribes()


func init_tribes() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var tribe = Global.scene.tribe.instantiate()
		tribes.add_child(tribe)
		tribe.set_attributes(input)
