extends Sprite

var ongoing_drag = -1 #DRAG OUTSIDE OF BOUNDRY
var return_accel = 20
var threshold = 10
onready var knob = $knob
onready var boundry = (texture.get_size().x * global_scale.x)/2
onready var knob_size = (($knob.texture.get_size().x * $knob.global_scale.x)/2) - 15

func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0, 0)) - knob.position
		knob.position += pos_difference * return_accel * delta

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist = (event.position - global_position).length()
#ACTUAL MOVING KNOB BIT
		if event_dist <= boundry or event.get_index() == ongoing_drag:
			knob.global_position = event.position #KNOB FOLLOWS FINGER
			if knob.position.length() > boundry - knob_size:
				knob.position = (knob.position.normalized() * (boundry - knob_size))
			ongoing_drag = event.get_index()

	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1

func _get_value():
	if knob.position.length() > threshold:
		var movement_info = [knob.position.normalized(), knob.position.length()]
		return movement_info
	return [Vector2(0, 0), 0]
