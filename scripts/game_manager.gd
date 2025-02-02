extends Node

var run_time = 0.0

var is_game_running = false

func _process(delta):
	if is_game_running:
		run_time += delta

func start_game():
	run_time = 0
	is_game_running = true

func end_game():
	is_game_running = false
	get_tree().change_scene_to_file("res://scenes/build_scenes/game_over_scene.tscn")
