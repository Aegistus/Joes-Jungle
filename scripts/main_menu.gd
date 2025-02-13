extends Node3D

func _on_start_game_button_pressed():
	GameManager.start_game()
	get_tree().change_scene_to_file("res://scenes/game_scenes/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_leaderboard_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/leaderboard.tscn")
