extends Control

@onready var label = $HBoxContainer/Label
@onready var progress_bar = $HBoxContainer/ProgressBar

func _ready():
	visible = false
	GameManager.on_killstreak_updated.connect(update_kill_count)

func update_kill_count(killstreak):
	if killstreak > 2:
		visible = true
	else:
		visible = false
	label.text = " x " + str(killstreak)

func _process(delta):
	progress_bar.value = GameManager.kill_streak_timer.time_left / GameManager.kill_streak_timer.wait_time
