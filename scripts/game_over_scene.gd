extends Node3D

@onready var final_time = $UI/CanvasLayer/Panel/FinalTime
@onready var cause_of_death = $UI/CanvasLayer/Panel2/CauseOfDeath

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var minutes : int = GameManager.run_time / 60
	var seconds := fmod(GameManager.run_time, 60)
	var milliseconds := fmod(GameManager.run_time, 1) * 100
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	final_time.text = "Final Time: " + time_string
	cause_of_death.text = "Cause of Death: " + GameManager.get_cause_of_death_text()

func _on_leaderboard_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/leaderboard.tscn")
