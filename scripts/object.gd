extends KinematicBody2D

export (PackedScene) var Card

const ACCELERATION = 0.085
var velocity = Vector2()

onready var player = get_node("/root/main/player/body")

func _ready():
	var rngen = RandomNumberGenerator.new()
	var limit = 300
	rngen.randomize()
	velocity.x = rngen.randi_range(-limit,limit)
	rngen.randomize()
	velocity.y = rngen.randi_range(-limit,limit)

func _on_TouchScreenButton_pressed():
	if (player.global_position - global_position).length() < 70:
		_tapped()

func _take():
	get_node("/root/main/HUD/inventory")._add_item(get_parent())
	queue_free()

func _tapped():
	var HUD = get_node("/root/main/HUD")
	if HUD.card != null:
		HUD._clear_card()
	var node = Card.instance()
	get_node("/root/main/HUD").add_child(node)
	node.object = self
	node.position = get_node("/root/main/HUD/card_pos").position
	HUD.card = node
	node._set_ready()

func _process(_delta):
	velocity.x = lerp(velocity.x, 0, ACCELERATION)
	velocity.y = lerp(velocity.y, 0, ACCELERATION)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if (player.global_position - global_position).length() < 70:
		$Sprite/glow.visible = true
	else:
		$Sprite/glow.visible = false

