extends Node2D

var active = true
var connected_room
var colliders = []
var setting_up = true
var player

func _on_Area2D_body_entered(body):
	colliders.append(body)
	if not setting_up:
		if body.get_parent() == player:
			body.collision_layer = 4
			body.collision_mask = 4
	if colliders.size() >= 4 and setting_up:
		queue_free()

func _on_Area2D_body_exited(body):
	if body.get_parent() == player:
		body.collision_layer = 1
		body.collision_mask = 1

func _on_Timer_timeout():
	setting_up = false
