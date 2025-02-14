extends Control

@onready var player = get_tree().get_first_node_in_group("player") as Player
@onready var progress_bar = $ProgressBar
@onready var label = $ProgressBar/Label

func _process(delta):
	if player.gun != null:
		progress_bar.max_value = player.gun.ergo_adjusted_accuracy
		progress_bar.value = player.gun.current_accuracy
		label.text = str(snapped(player.gun.current_accuracy, 1))
