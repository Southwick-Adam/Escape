extends RigidBody2D

export (PackedScene) var Door

var size

var room_number
var tile_size = 32

var player

var nbors_dir = {
	"top" : [],
	"bottom" : [],
	"left" : [],
	"right" : [],
}
var nbors = []
var connected_rooms = []

func _make_room(_pos, _size):
	position = _pos
	size = _size * tile_size
	var s = RectangleShape2D.new()
	var sh = RectangleShape2D.new()
	s.extents = size
	sh.extents = size - Vector2(11,11)
	$CollisionShape2D.shape = s
	$Area2D/CollisionShape2D.shape = sh
	$floor.scale = (_size * 2) - Vector2(1,1)

func _check_neighbors():
	$top.position.y = -size.y - 7
	$bottom.position.y = size.y + 7
	$left.position.x = -size.x - 7
	$right.position.x = size.x + 7
	var n = 1
	while n <= 4:
		var rect = RectangleShape2D.new()
		if n < 3:
			rect.extents = Vector2(size.x - 150,7)
		else:
			rect.extents = Vector2(7,size.y - 150)
		get_child(n).get_child(0).shape = rect
		n += 1
	yield(get_tree().create_timer(0.2), 'timeout')
	nbors.erase(self)
	for nbor in nbors:
		var pos_dif = (nbor.global_position - global_position)
		if nbors_dir["left"].has(nbor) or nbors_dir["right"].has(nbor):
			if abs(pos_dif.x) + 16 < (size.x + nbor.size.x):
				queue_free()
		else:
			if abs(pos_dif.y) + 16 < (size.y + nbor.size.y):
				queue_free()
	if nbors.size() <= 0:
		queue_free()
	else:
		var m = 0
		while m < 5:
			get_child(m).queue_free()
			m += 1
	_set_doors()

func _make_walls():
	var frame = StaticBody2D.new()
	add_child(frame)
	var n = 0
	while n < 4:
		var wall = CollisionShape2D.new()
		frame.add_child(wall)
		var shape = RectangleShape2D.new()
		shape.extents = Vector2(16,16)
		wall.shape = shape
		if n < 2:
			shape.extents.x = size.x
			wall.position.y = (size.y)* pow(-1,n)
		else:
			shape.extents.y = size.y
			wall.position.x = size.x * pow(-1,n)
		n += 1
	frame.collision_layer = 3
	frame.collision_layer = 3

func _set_doors():
	for nbor in nbors:
		if not nbor.connected_rooms.has(self):
			connected_rooms.append(nbor)
			var n_pos = nbor.global_position
			var pos_dif = n_pos - global_position #POS_DIF IS GLOBAL
			var slope
			if pos_dif.x != 0:
				slope = pos_dif.y/pos_dif.x
			else:
				slope = 0
			var n_direction = Vector2(0,0)
			if nbors_dir["top"].has(nbor):
				n_direction.y = -1
			elif nbors_dir["bottom"].has(nbor):
				n_direction.y = 1
			elif nbors_dir["left"].has(nbor):
				n_direction.x = -1
			elif nbors_dir["right"].has(nbor):
				n_direction.x = 1
			var wall_pos = (size * n_direction)
			if wall_pos.x == 0:
				if slope != 0:
					wall_pos.x = wall_pos.y/slope
				else:
					wall_pos.x = 0
			elif wall_pos.y == 0:
				wall_pos.y = wall_pos.x * slope
			
			var node = Door.instance()
			add_child(node)
			node.position = wall_pos
			node.connected_room = nbor
			node.rotation_degrees = abs(n_direction.x) * 90
	_finalize()

func _finalize():
	$Area2D.monitoring = true

func _on_top_body_entered(body):
	if not nbors.has(body):
		nbors_dir["top"].append(body)
		nbors.append(body)

func _on_bottom_body_entered(body):
	if not nbors.has(body):
		nbors_dir["bottom"].append(body)
		nbors.append(body)

func _on_left_body_entered(body):
	if not nbors.has(body):
		nbors_dir["left"].append(body)
		nbors.append(body)

func _on_right_body_entered(body):
	if not nbors.has(body):
		nbors_dir["right"].append(body)
		nbors.append(body)

func _on_Area2D_area_entered(area):
	if area.get_parent().get_parent() == player:
		get_parent().get_parent()._change_rooms(self)
		for child in get_parent().get_children():
			child.z_index = -2
		z_index = 0
