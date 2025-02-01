extends Node3D

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/build_scenes/main.tscn")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/build_scenes/main_menu.tscn")
