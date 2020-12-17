extends CanvasLayer

var card = null

func _clear_card():
	card.queue_free()
	card = null

func _atk_btn(boo, tex):
	$attack/Sprite/icon.texture = tex
	$attack/Sprite.visible = boo

func _on_attack_pressed():
	if get_node("inventory").active_item != null and $attack/Sprite.visible:
		get_node("inventory").active_item._use()
