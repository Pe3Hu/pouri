extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var mainland = $HBox/Mainland


func _ready() -> void:
	var input = {}
	input.sketch = self
	mainland.set_attributes(input)
	cradle.set_attributes(input)
	
	var land = mainland.lands.get_child(1)
	
	for tribe in cradle.tribes.get_children():
		land.add_tribe(tribe)
