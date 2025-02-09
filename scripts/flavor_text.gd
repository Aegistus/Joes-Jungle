extends Label

func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), .5)
	tween.tween_property(self, "scale", Vector2(1, 1), 1)
