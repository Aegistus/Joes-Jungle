extends Control

@onready var player = get_tree().get_first_node_in_group("player") as Player
@onready var progress_bar = $ProgressBar

func _process(delta):
	if player.gun != null:
		progress_bar.max_value = player.gun.base_accuracy
		progress_bar.value = player.gun.current_accuracy
