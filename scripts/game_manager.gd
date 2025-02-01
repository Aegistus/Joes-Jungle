extends Node

var run_time = 0.0

var is_game_running = true

func _process(delta):
	if is_game_running:
		run_time += delta
