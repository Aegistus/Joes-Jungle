class_name BuildGun
extends Gun

const BARRICADE_EMPLACEMENT = preload("res://scenes/emplacements/barricade_emplacement.tscn")

var all_builds = [BARRICADE_EMPLACEMENT, ]
var currently_selected_build
var current_emplacement_ghost
var is_equipped = false
var player : Player
var reticle

func _ready():
	currently_selected_build = all_builds[0]

func shoot():
	var emplacement = BARRICADE_EMPLACEMENT.instantiate()
	get_tree().root.add_child(emplacement)
	emplacement.global_position = reticle.global_position

func equip(player : Node3D):
	is_equipped = true
	self.player = player as Player
	if reticle == null:
		reticle = get_tree().get_first_node_in_group("aim_reticle")
	spawn_emplacement_ghost()

func unequip():
	is_equipped = false
	current_emplacement_ghost.queue_free()

func _physics_process(delta):
	if is_equipped:
		if not reticle.visible:
			current_emplacement_ghost.visible = false
		elif current_emplacement_ghost != null:
			current_emplacement_ghost.visible = true
			current_emplacement_ghost.global_position = reticle.global_position

func spawn_emplacement_ghost():
	current_emplacement_ghost = currently_selected_build.instantiate()
	player.add_child(current_emplacement_ghost)
	current_emplacement_ghost.global_position = reticle.global_position
