extends Node2D

export (PackedScene) var Player
export (PackedScene) var Map

##3TEMP
export (PackedScene) var Weapon
###
var player

func _spawn_players():
	var node = Player.instance()
	call_deferred("add_child", node)
	node.global_position = get_global_mouse_position()
	get_node("floor").player = node
	for child in get_node("floor/rooms").get_children():
		child.player = node
	for door in get_tree().get_nodes_in_group("door"):
		door.player = node
	player = node
	_spawn_map()

func _spawn_map():
	var node = Map.instance()
	$HUD.call_deferred("add_child", node)
	node.position = get_viewport_rect().size / 2
	node.player = player

func _set_cam(r):
	$Camera2D.position = r.position + Vector2(r.size.x/8,0)

func _on_Timer_timeout():
	_spawn_players()

func _input(event):
	if event.is_action_pressed("ui_up"):
		$Camera2D.zoom = Vector2(5,5)
	elif event.is_action_pressed("ui_down"):
		$Camera2D.zoom = Vector2(1,1)
	elif event.is_action_pressed("ui_accept"):
		get_node("HUD/map").visible = !get_node("HUD/map").visible
	elif event.is_action_pressed("ui_left"):
		var node = Weapon.instance()
		call_deferred("add_child", node)
		node.global_position = get_global_mouse_position()
