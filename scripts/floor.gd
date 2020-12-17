extends Node2D

export (PackedScene) var Room

var tile_size = 32
var num_rooms = 20
var min_size = Vector2(8,7)
var max_size = Vector2(11,7)

var player

var hspread = 800

var ready = false

func _ready():
	randomize()
	_make_rooms()

func _make_rooms():
	var n = 0
	while n < num_rooms:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var node = Room.instance()
		var w = rng.randi_range(min_size.x, max_size.x)
		rng.randomize()
		var h = rng.randi_range(min_size.y, max_size.y)
		node._make_room(pos, Vector2(w, h))
		$rooms.add_child(node)
		node.room_number = n
		n += 1
# wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
# cull rooms
	for room in $rooms.get_children():
		room.mode = RigidBody2D.MODE_STATIC
		room._check_neighbors()
		room._make_walls()
		
func _change_rooms(r):
	player.current_room = r
	get_node("/root/main")._set_cam(r)
	for door in get_tree().get_nodes_in_group("door"):
		var pos_dif = door.global_position - r.global_position 
		if abs(pos_dif.x) > (r.size.x + 20) or abs(pos_dif.y) > (r.size.y + 20):
			door.visible = false
		else:
			door.visible = true
	get_node("/root/main/HUD/map")._add_room(r)
