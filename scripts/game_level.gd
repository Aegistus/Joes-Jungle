extends Node3D

func _ready():
	if not GameManager.is_game_running:
		GameManager.start_game()
