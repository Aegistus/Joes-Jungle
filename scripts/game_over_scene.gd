extends Node3D

@onready var final_time = $UI/CanvasLayer/Panel/FinalTime

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var minutes : int = GameManager.run_time / 60
	var seconds := fmod(GameManager.run_time, 60)
	var milliseconds := fmod(GameManager.run_time, 1) * 100
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	final_time.text = "Final Time: " + time_string

func _on_restart_button_pressed():
	GameManager.start_game()
	get_tree().change_scene_to_file("res://scenes/build_scenes/main.tscn")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/build_scenes/main_menu.tscn")
