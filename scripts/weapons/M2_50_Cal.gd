class_name M2_50Cal
extends Interactable

var being_used = false

func interact_start():
	being_used = true
	var player = get_tree().get_first_node_in_group("player") as Player
	player.use_emplacement()
