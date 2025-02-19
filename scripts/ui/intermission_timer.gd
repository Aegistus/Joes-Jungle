extends Panel

@onready var label = $Label

var in_intermission = true

func _ready():
	GameManager.on_intermission_start.connect(show_timer)
	GameManager.on_intermission_end.connect(hide_timer)

func show_timer():
	visible = true
	in_intermission = true

func hide_timer():
	visible = false
	in_intermission = false

func _process(delta):
	if in_intermission:
		var minutes : int = GameManager.intermission_timer.time_left / 60
		var seconds := fmod(GameManager.intermission_timer.time_left, 60)
		#var milliseconds := fmod(GameManager.intermission_timer.time_left, 1) * 100
		var time_string := "%02d:%02d" % [minutes, seconds]#, milliseconds]
		label.text = time_string
