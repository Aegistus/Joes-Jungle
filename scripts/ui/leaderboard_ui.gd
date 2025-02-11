extends Node3D

@onready var entry_parent = $UI/CanvasLayer/VBoxContainer/Leaderboard/ScrollContainer/EntryParent

const LEADERBOARD_ENTRY = preload("res://scenes/ui/leaderboard_entry.tscn")

func _ready():
	var runs = GameManager.all_player_runs
	for i in runs.size():
		if runs[i] != null:
			var entry = LEADERBOARD_ENTRY.instantiate() as LeaderboardEntry
			entry_parent.add_child(entry)
			entry.rank.text = str(runs[i].rank)
			entry.player_name.text = runs[i].player_name
			var minutes : int = runs[i].time / 60
			var seconds := fmod(runs[i].time, 60)
			var milliseconds := fmod(runs[i].time, 1) * 100
			var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
			entry.time.text = time_string

func _on_start_new_run_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/main.tscn")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/main_menu.tscn")
