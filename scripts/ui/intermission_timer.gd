extends Panel

@onready var label = $Label
@onready var ticking_audio_player = $TickingAudioPlayer
@onready var skip_intermission_button = $SkipIntermissionButton

var tick_starting_time : float = 9
var in_intermission = true
var ticking_started = false

func _ready():
	GameManager.on_intermission_start.connect(show_timer)
	GameManager.on_intermission_end.connect(hide_timer)

func show_timer():
	visible = true
	skip_intermission_button.visible = true
	in_intermission = true
	ticking_started = false

func hide_timer():
	visible = false
	in_intermission = false
	ticking_audio_player.stop()

func _process(delta):
	if in_intermission:
		var minutes : int = GameManager.intermission_timer.time_left / 60
		var seconds := fmod(GameManager.intermission_timer.time_left, 60)
		#var milliseconds := fmod(GameManager.intermission_timer.time_left, 1) * 100
		var time_string := "%02d:%02d" % [minutes, seconds]#, milliseconds]
		label.text = time_string
		if !ticking_started and GameManager.intermission_timer.time_left < tick_starting_time:
			ticking_started = true
			ticking_audio_player.play()
		if GameManager.intermission_timer.time_left < 10:
			skip_intermission_button.visible = false
