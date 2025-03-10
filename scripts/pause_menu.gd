extends Control

@onready var canvas_layer = $CanvasLayer

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused == true:
		canvas_layer.hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	elif get_tree().paused == false:
		canvas_layer.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func exit_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game_scenes/main_menu.tscn")

func exit_game():
	get_tree().paused = false
	get_tree().quit()
