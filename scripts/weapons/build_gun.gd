class_name BuildGun
extends Gun

signal on_equip
signal on_unequip
signal on_change_selected_build(index : int)

@export var all_builds : Array[EmplacementStats]

var current_emplacement : EmplacementStats
var current_index = 0
var current_emplacement_ghost : Node3D
var is_equipped = false
var player : Player
var reticle
var overlapping = false

func _ready():
	current_emplacement = all_builds[current_index]

func shoot():
	if current_emplacement_ghost.valid_placement and GameManager.current_scrap >= current_emplacement.cost:
		var emplacement = current_emplacement.emplacement_scene.instantiate() as Emplacement
		get_tree().current_scene.add_child(emplacement)
		emplacement.global_position = reticle.global_position
		emplacement.global_rotation = current_emplacement_ghost.global_rotation
		emplacement.place()
		GameManager.spend_scrap(current_emplacement.cost)
		if (player.movement_state_machine as StateMachine).current_state != player.build_construct_state:
			(player.movement_state_machine as StateMachine).transition_to(player.build_construct_state)
	else:
		%InvalidErrorAudioPlayer.play()

func equip(player : Node3D):
	is_equipped = true
	self.player = player as Player
	if reticle == null:
		reticle = get_tree().get_first_node_in_group("aim_reticle")
	spawn_emplacement_ghost()
	on_equip.emit()

func unequip():
	is_equipped = false
	current_emplacement_ghost.queue_free()
	on_unequip.emit()

func _physics_process(delta):
	if is_equipped:
		if not reticle.visible:
			current_emplacement_ghost.visible = false
		elif current_emplacement_ghost != null:
			current_emplacement_ghost.visible = true
			current_emplacement_ghost.global_position = reticle.global_position
		if Input.is_action_just_pressed("emplacements_scroll_up"):
			current_index = (current_index - 1) % all_builds.size()
			if current_index == -1:
				current_index = all_builds.size() - 1
			select_new_emplacement()
		if Input.is_action_just_pressed("emplacements_scroll_down"):
			current_index = (current_index + 1) % all_builds.size()
			select_new_emplacement()

func spawn_emplacement_ghost():
	current_emplacement_ghost = current_emplacement.ghost_scene.instantiate() as EmplacementGhost
	player.add_child(current_emplacement_ghost)
	current_emplacement_ghost.global_position = reticle.global_position

func rotate_right():
	current_emplacement_ghost.rotate_object_local(Vector3.UP, PI/4.0)

func rotate_left():
	current_emplacement_ghost.rotate_object_local(Vector3.UP, -PI/4.0)

func select_new_emplacement():
	current_emplacement = all_builds[current_index]
	current_emplacement_ghost.queue_free()
	spawn_emplacement_ghost()
	on_change_selected_build.emit(current_index)
