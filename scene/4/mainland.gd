extends MarginContainer


@onready var lands = $HBox/Lands
@onready var battlegrounds = $HBox/Battlegrounds

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_lands()


func init_lands() -> void:
	for _i in 3:
		for _j in 1:
			var input = {}
			input.mainland = self
			input.grid = Vector2(_j, _i)
		
			var land = Global.scene.land.instantiate()
			lands.add_child(land)
			land.set_attributes(input)
