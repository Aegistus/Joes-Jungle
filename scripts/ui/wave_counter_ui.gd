extends Label

@export var animation_time := .25
@export var fade_in_time := .2

var resting_position : Vector2
var animation_start_position : Vector2

func _ready():
	visible = false
	GameManager.on_wave_start.connect(update_counter)
	resting_position = position
	animation_start_position = Vector2(2000, position.y)

func update_counter():
	visible = false
	position = animation_start_position
	text = str(GameManager.current_wave)
	var tween = get_tree().create_tween()
	tween.tween_interval(6)
	modulate.a = 0
	visible = true
	tween.tween_property(self, "position", resting_position, animation_time)
	tween.parallel().tween_property(self, "modulate:a", 1, fade_in_time)
