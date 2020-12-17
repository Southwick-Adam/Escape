extends Node2D

export (PackedScene) var Obj

var type #ice_pick, knife, sword, pistol, shotgun, rifle
var chance = [0.2, 0.4, 0.58, 0.74, 0.88, 1]
var item_name
var texture
var effect_range
var cooldown
var damage
var accuracy
var uses = -1
var stackable = false

var active = false

func _ready():
	randomize()
	var rng = randf()
	var n = 0
	while n < 6:
		if rng <= chance[n]:
			type = n
			break
		n += 1
	_set_values()
	var node = Obj.instance()
	add_child(node)
	node.get_child(1).modulate = Color(0.392157, 0, 0)

func _set_values():
	if type == 0:
		item_name = "Shiv"
		texture = load("res://assets/item_assets/shiv.png")
		effect_range = 1
		cooldown = 0.4
		damage = 10
		accuracy = 0.9
	elif type == 1:
		item_name = "Knife"
		texture = load("res://assets/item_assets/knife.png")
		effect_range = 2
		cooldown = 0.75
		damage = 20
		accuracy = .85
	elif type == 2:
		item_name = "Sword"
		texture = load("res://assets/item_assets/sword.png")
		effect_range = 3
		cooldown = 1
		damage = 25
		accuracy = .85
	elif type == 3:
		item_name = "Pistol"
		texture = load("res://assets/item_assets/pistol.png")
		effect_range = 6
		cooldown = .75
		damage = 25
		accuracy = .7
		uses = 3
	elif type == 4:
		item_name = "Shotgun"
		texture = load("res://assets/item_assets/shotgun.png")
		effect_range = 4
		cooldown = 1.2
		damage = 40
		accuracy = .75
		uses = 3
	elif type == 5:
		item_name = "Rifle"
		texture = load("res://assets/item_assets/rifle.png")
		effect_range = 8
		cooldown = 1.2
		damage = 35
		accuracy = .9
		uses = 3
#VARY VALUES A LITTLE
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	effect_range = effect_range * rng.randf_range(0.9, 1.1)
	rng.randomize()
	damage = damage * rng.randf_range(0.85, 1.15)
	rng.randomize()
	accuracy = accuracy * rng.randf_range(0.9, 1.1)

func _use():
	active = true
