extends Node2D

var object
onready var boundry = Vector2()
onready var player = get_node("/root/main/player/body")
var fade = false
var item

func _set_ready():
	item = object.get_parent()
#SET VALUES
	$name.text = item.item_name
	$icon.texture = item.texture

func _process(_delta):
	var source_dist = (player.global_position - object.global_position).length()
	if source_dist > 70:
		fade = true
	if fade:
		modulate.a -= 0.07
		if modulate.a < 0.07:
			queue_free()
	if object == null:
		queue_free()

func _on_TouchScreenButton_pressed():
	if not fade:
		object._take()
		queue_free()
