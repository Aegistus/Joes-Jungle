extends Panel

@onready var label = $Label

func _process(delta):
	var minutes : int = GameManager.run_time / 60
	var seconds := fmod(GameManager.run_time, 60)
	var milliseconds := fmod(GameManager.run_time, 1) * 100
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	label.text = time_string
