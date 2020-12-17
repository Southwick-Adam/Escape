extends Node2D

export (PackedScene) var Inventory

const SPEED = 200
const ACCELERATION = 0.4
var velocity = Vector2()

var current_room

onready var controler = get_node("/root/main/HUD/control")

func _process(_delta):
	var perc = (controler._get_value()[1]/controler.boundry) * 1.2
	var direction = controler._get_value()[0]
	velocity.x = lerp(velocity.x, SPEED * direction.x, ACCELERATION)
	velocity.y = lerp(velocity.y, SPEED * direction.y, ACCELERATION)
	velocity = velocity * perc
	velocity = $body.move_and_slide(velocity, Vector2(0,-1))
	var knob_angle = atan2(direction.y,direction.x)
	if direction != Vector2(0,0):
		$body.rotation = (knob_angle + PI/2)
