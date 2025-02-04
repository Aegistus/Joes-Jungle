extends Node

signal on_point_change(points)

var run_time = 0.0
var is_game_running = false

var current_points = 0

func _process(delta):
	if is_game_running:
		run_time += delta

func start_game():
	run_time = 0
	current_points = 0
	is_game_running = true

func end_game():
	is_game_running = false
	get_tree().change_scene_to_file("res://scenes/game_scenes/game_over_scene.tscn")

func add_points(amount):
	current_points += amount
	on_point_change.emit(current_points)

func spend_points(amount):
	current_points -= amount
	on_point_change.emit(current_points)
