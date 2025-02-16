class_name BuildGun
extends Gun

const BARRICADE_EMPLACEMENT = preload("res://scenes/emplacements/barricade_emplacement.tscn")

func shoot():
	var reticle = get_tree().get_first_node_in_group("aim_reticle")
	var emplacement = BARRICADE_EMPLACEMENT.instantiate()
	get_tree().root.add_child(emplacement)
	emplacement.global_position = reticle.global_position
