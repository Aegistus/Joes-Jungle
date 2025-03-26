extends Node

const FONT_SIZE = 36
const RISE_HEIGHT = .5
const DURATION = .5
const FLOATING_TEXT = preload("res://scenes/ui/floating_text.tscn")

func display_text(text: String, position: Vector3, color: Color = Color.WHITE):
	var floating_text = FLOATING_TEXT.instantiate()
	var label = floating_text.get_node("Label3D") as Label3D
	add_child(floating_text)
	floating_text.global_position = position
	label.text = text
	#label.z_index = 5
	
	label.modulate = color
	label.font_size = FONT_SIZE
	label.outline_modulate = Color.BLACK
	label.outline_size = 1
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y + RISE_HEIGHT, DURATION).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0, DURATION)
	tween.tween_property(label, "outline_modulate:a", 0, DURATION)
	
	await tween.finished
	floating_text.queue_free()
	
