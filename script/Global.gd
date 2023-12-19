extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.particle = ["strength", "dexterity", "intellect", "will"]
	arr.parameter = ["type", "subtype", "value"]
	arr.indicator = ["health", "barrier", "energy"]
	arr.ability = ["ordinary", "advanced", "ultimate"]
	arr.advanced = [25, 50, 100]
	arr.source = ["elemental", "physical"]
	arr.order = ["primary", "secondary"]
	arr.offense = ["critical", "overload", "lifesteal"]
	arr.defense = ["dodge", "armor"]


func init_num() -> void:
	num.index = {}
	
	num.core = {}
	num.core.base = 100
	
	num.particle = {}
	num.particle.min = 10
	num.particle.max = 39
	
	num.weight = {}
	num.weight.energy = 7.2
	num.weight.ordinary = 60
	num.weight.ultimate = 1000
	
	num.aspect = {}
	num.aspect.primary = 0.6
	num.aspect.secondary = 0.4


func init_dict() -> void:
	init_neighbor()
	init_cast()
	init_parameter()
	init_keyword()
	init_priority()
	init_totem()
	init_ultimate()
	init_buff()
	init_experience()
	init_ornament()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_cast() -> void:
	dict.energy = {}
	dict.energy.type = {}
	dict.energy.type["strength"] = "fury"
	dict.energy.type["dexterity"] = "mana"
	dict.energy.type["intellect"] = "mana"
	dict.energy.type["will"] = "fury"
	
	dict.cast = {}
	dict.cast.duration = {}
	dict.cast.duration["fast"] = {}
	dict.cast.duration["fast"]["fairly"] = 1
	dict.cast.duration["fast"]["slightly"] = 1.2
	dict.cast.duration["slow"] = {}
	dict.cast.duration["slow"]["slightly"] = 1.5
	dict.cast.duration["slow"]["fairly"] = 2
	
	dict.cast.energy = {}
	dict.cast.energy["fast"] = {}
	dict.cast.energy["slow"] = {}
	dict.cast.energy["fast"]["fairly"] = {}
	dict.cast.energy["fast"]["slightly"] = {}
	dict.cast.energy["slow"]["slightly"] = {}
	dict.cast.energy["slow"]["fairly"] = {}
	dict.cast.energy["fast"]["fairly"]["physical"] = 6
	dict.cast.energy["fast"]["slightly"]["physical"] = 7
	dict.cast.energy["slow"]["slightly"]["physical"] = 9
	dict.cast.energy["slow"]["fairly"]["physical"] = 12
	dict.cast.energy["fast"]["fairly"]["elemental"] = 4
	dict.cast.energy["fast"]["slightly"]["elemental"] = 5
	dict.cast.energy["slow"]["slightly"]["elemental"] = 6
	dict.cast.energy["slow"]["fairly"]["elemental"] = 8


func init_parameter() -> void:
	dict.parameter = {}
	dict.parameter.index = {}
	dict.parameter.rarity = {}
	dict.parameter.rarity.common = {}
	
	for particle in arr.particle:
		dict.parameter.rarity[particle] = {}
	
	var path = "res://asset/json/pouri_parameter.json"
	var array = load_data(path)
	
	for parameter in array:
		var data = {}
		
		for key in parameter:
			if key != "index":
				data[key] = parameter[key]
		
		dict.parameter.index[parameter.index] = data
		
		for particle in arr.particle:
			if parameter.has(particle):
				dict.parameter.rarity[particle][parameter.index] = parameter[particle]
		
		dict.parameter.rarity.common[parameter.index] = parameter.rarity


func init_keyword() -> void:
	dict.keyword = {}
	dict.keyword.title = {}
	dict.keyword.type = {}
	dict.keyword.subtype = {}
	
	var path = "res://asset/json/pouri_keyword.json"
	var array = load_data(path)
	
	for keyword in array:
		var data = {}
		
		for key in keyword:
			if key != "title":
				data[key] = keyword[key]
		
		dict.keyword.title[keyword.title] = data
		
		if !dict.keyword.type.has(keyword.type):
			dict.keyword.type[keyword.type] = []
		
		if !dict.keyword.subtype.has(keyword.subtype):
			dict.keyword.subtype[keyword.subtype] = []
		
		dict.keyword.type[keyword.type].append(keyword.title)
		dict.keyword.subtype[keyword.subtype].append(keyword.title)


func init_priority() -> void:
	dict.priority = {}
	dict.priority.index = {}
	
	var path = "res://asset/json/pouri_priority.json"
	var array = load_data(path)
	
	for priority in array:
		var data = {}
		
		for key in priority:
			if key != "index":
				data[key] = priority[key]
		
		dict.priority.index[priority.index] = data


func init_totem() -> void:
	dict.totem = {}
	dict.totem.index = {}
	
	var path = "res://asset/json/pouri_totem.json"
	var array = load_data(path)
	
	for totem in array:
		var data = {}
		data.bonus = {}
		data.aspect = {}
		
		for key in totem:
			if key != "index":
				var words = key.split(" ")
				
				if words.has("aspect"):
					data.aspect[words[0]] = totem[key]
				else:
					if !data.bonus.has(words[1]):
						data.bonus[words[1]] = {}
					
					data.bonus[words[1]][words[0]] = totem[key]
				data[key] = totem[key]
		
		dict.totem.index[totem.index] = data


func init_ultimate() -> void:
	dict.ultimate = {}
	dict.ultimate.index = {}
	
	var path = "res://asset/json/pouri_ultimate.json"
	var array = load_data(path)
	
	for ultimate in array:
		var data = {}
		data.particle = {}
		data.condition = {}
		data.buff = {}
		
		for key in ultimate:
			if key != "index":
				var words = key.split(" ")
				
				if words[0] != "buff":
					data[words[0]][words[1]] = ultimate[key]
				else:
					if !data[words[0]].has(words[2]):
						data[words[0]][words[2]] = {}
					
					data[words[0]][words[2]][words[1]] = ultimate[key]
		
		dict.ultimate.index[ultimate.index] = data


func init_buff() -> void:
	dict.buff = {}
	dict.buff.index = {}
	
	var path = "res://asset/json/pouri_buff.json"
	var array = load_data(path)
	
	for buff in array:
		var data = {}
		
		for key in buff:
			if key != "index":
				data[key] = buff[key]
		
		dict.buff.index[buff.index] = data


func init_experience() -> void:
	dict.experience = {}
	dict.experience.level = {}
	
	var path = "res://asset/json/pouri_experience.json"
	var array = load_data(path)
	
	for experience in array:
		dict.experience.level[int(experience.level)] = experience.limit


func init_ornament() -> void:
	dict.ornament = {}
	dict.ornament.order = {}
	
	var path = "res://asset/json/pouri_ornament.json"
	var array = load_data(path)
	
	for ornament in array:
		var data = {}
		
		for key in ornament:
			if key != "order":
				data[key] = ornament[key]
		
		dict.ornament.order[ornament.order] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.tribe = load("res://scene/1/tribe.tscn")
	scene.creature = load("res://scene/1/creature.tscn")
	scene.troop = load("res://scene/1/troop.tscn")
	
	scene.particle = load("res://scene/2/particle.tscn")
	scene.parameter = load("res://scene/2/parameter.tscn")
	
	scene.buff = load("res://scene/3/buff.tscn")
	
	scene.land = load("res://scene/4/land.tscn")
	scene.battleground = load("res://scene/4/battleground.tscn")
	
	scene.ornament = load("res://scene/5/ornament.tscn")
	scene.perk = load("res://scene/5/perk.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(164, 16)
	
	vec.size.particle = Vector2(32, 32)
	vec.size.parameter = Vector2(64, 64)
	vec.size.couple = Vector2(48, 48)
	vec.size.land = Vector2(32, 32)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.particle = {}
	color.particle.strength = Color.from_hsv(0 / h, 0.8, 0.6)
	color.particle.dexterity = Color.from_hsv(120 / h, 0.8, 0.6)
	color.particle.intellect = Color.from_hsv(210 / h, 0.8, 0.6)
	color.particle.will = Color.from_hsv(60 / h, 0.8, 0.6)
	color.particle.level = Color.from_hsv(0 / h, 0.0, 0.75)
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0, 0.9, 0.7)
	color.indicator.health.background = Color.from_hsv(0, 0.5, 0.9)
	color.indicator.barrier = {}
	color.indicator.barrier.fill = Color.from_hsv(190 / h, 0.9, 0.7)
	color.indicator.barrier.background = Color.from_hsv(190 / h, 0.5, 0.9)
	color.indicator.mana = {}
	color.indicator.mana.fill = Color.from_hsv(150 / h, 0.9, 0.7)
	color.indicator.mana.background = Color.from_hsv(150 / h, 0.5, 0.9)
	color.indicator.fury = {}
	color.indicator.fury.fill = Color.from_hsv(270 / h, 0.9, 0.7)
	color.indicator.fury.background = Color.from_hsv(270 / h, 0.5, 0.9)
	color.indicator.experience = {}
	color.indicator.experience.fill = Color.from_hsv(60 / h, 0.9, 0.7)
	color.indicator.experience.background = Color.from_hsv(60 / h, 0.5, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
