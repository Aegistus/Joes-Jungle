extends Node

func _ready():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies.size():
		enemies[i].hit(1000, Vector3.FORWARD, Vector3.BACK)
