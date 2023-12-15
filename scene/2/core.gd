extends MarginContainer


@onready var particles = $Particles
@onready var strength = $Particles/Strength
@onready var dexterity = $Particles/Dexterity
@onready var intellect = $Particles/Intellect
@onready var will = $Particles/Will

var creature = null


func set_attributes(input_: Dictionary) -> void:
	creature = input_.creature
	
	init_particles()


func init_particles() -> void:
	var input = {}
	input.core = self
	
	for type in Global.arr.particle:
		input.type = type
		var particle = get(type)
		particle.set_attributes(input)



