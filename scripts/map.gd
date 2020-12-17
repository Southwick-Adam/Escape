extends Node2D

var player_s

var room_list = {}
var player

func _add_room(r):
	for room in room_list:
		room_list[room].self_modulate = Color(1,1,1)
	if not room_list.has(r):
		var sprite = Sprite.new()
		add_child(sprite)
		sprite.texture = load("res://assets/block.png")
		sprite.self_modulate = Color(0,1,0)
		sprite.position = r.position/10
		sprite.scale = (r.size/32)/8
		room_list[r] = sprite
	room_list[r].self_modulate = Color(0,1,0)
	for door in get_tree().get_nodes_in_group("door"):
		if door.visible:
			var sprite = Sprite.new()
			add_child(sprite)
			sprite.texture = load("res://assets/block.png")
			sprite.self_modulate = Color(0.619608, 0.784314, 0.901961)
			sprite.position = door.global_position/10
			sprite.scale = Vector2(0.2,0.3)
			sprite.rotation = door.rotation
