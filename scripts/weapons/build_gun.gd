class_name BuildGun
extends Gun

const BARRICADE_EMPLACEMENT = preload("res://scenes/emplacements/barricade_emplacement.tscn")
const BARRICADE_GHOST = preload("res://scenes/emplacements/barricade_ghost.tscn")
const CLAYMORE_MINE = preload("res://scenes/emplacements/claymore_mine.tscn")
const CLAYMORE_GHOST = preload("res://scenes/emplacements/claymore_ghost.tscn")

var all_builds = [BARRICADE_EMPLACEMENT, CLAYMORE_MINE]
var build_blueprint_dict = {
	BARRICADE_EMPLACEMENT: BARRICADE_GHOST,
	CLAYMORE_MINE: CLAYMORE_GHOST,
}
var build_costs = {
	BARRICADE_EMPLACEMENT: 1000,
	CLAYMORE_MINE: 1000,
}
var currently_selected_build
var current_index = 0
var current_emplacement_ghost : Node3D
var is_equipped = false
var player : Player
var reticle
var overlapping = false

func _ready():
	currently_selected_build = all_builds[current_index]

func shoot():
	if current_emplacement_ghost.valid_placement and GameManager.current_points >= build_costs[currently_selected_build]:
		var emplacement = currently_selected_build.instantiate() as Emplacement
		get_tree().root.add_child(emplacement)
		emplacement.global_position = reticle.global_position
		emplacement.global_rotation = current_emplacement_ghost.global_rotation
		emplacement.place()
		GameManager.spend_points(build_costs[currently_selected_build])
	else:
		%InvalidErrorAudioPlayer.play()

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
		if Input.is_action_just_pressed("emplacements_scroll_down"):
			current_index = (current_index - 1) % all_builds.size()
			select_new_emplacement()
		if Input.is_action_just_pressed("emplacements_scroll_up"):
			current_index = (current_index + 1) % all_builds.size()
			select_new_emplacement()

func spawn_emplacement_ghost():
	current_emplacement_ghost = build_blueprint_dict[currently_selected_build].instantiate() as EmplacementGhost
	player.add_child(current_emplacement_ghost)
	current_emplacement_ghost.global_position = reticle.global_position

func rotate_right():
	current_emplacement_ghost.rotate_object_local(Vector3.UP, PI/4.0)

func rotate_left():
	current_emplacement_ghost.rotate_object_local(Vector3.UP, -PI/4.0)

func select_new_emplacement():
	currently_selected_build = all_builds[current_index]
	current_emplacement_ghost.queue_free()
	spawn_emplacement_ghost()
