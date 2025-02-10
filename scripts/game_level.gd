extends Node3D

const WATERING_BUSH = preload("res://scenes/scenery/watering_bush.tscn")
const AMMO_BOX = preload("res://scenes/ammo_box.tscn")
const FRUIT_PUNCH_BOWL = preload("res://scenes/fruit_punch_bowl.tscn")
const SHOP_LMG = preload("res://scenes/shop_lmg.tscn")
const SHOP_RIFLE = preload("res://scenes/shop_rifle.tscn")
const SHOP_SHOTGUN = preload("res://scenes/shop_shotgun.tscn")
const SHOP_SMG = preload("res://scenes/shop_smg.tscn")
const PLAYER = preload("res://scenes/player.tscn")
const AIM_RETICLE = preload("res://scenes/aim_reticle.tscn")
const PLAYER_UI = preload("res://scenes/ui/player_ui.tscn")
const PAUSE_MENU = preload("res://scenes/ui/pause_menu.tscn")

@onready var objective_spawn_points_parent = $ObjectiveSpawnPointsParent
@onready var player_spawn_point = $PlayerSpawnPoint

var obj_spawns
var index = -1

func _ready():
	if not GameManager.is_game_running:
		GameManager.start_game()
	obj_spawns = objective_spawn_points_parent.get_children() as Array[Node3D]
	obj_spawns.shuffle()
	# bushes
	var bush = place_objective(WATERING_BUSH)
	(bush as WateringBush).id = index
	bush = place_objective(WATERING_BUSH)
	(bush as WateringBush).id = index
	bush = place_objective(WATERING_BUSH)
	(bush as WateringBush).id = index
	# ammo boxes
	place_objective(AMMO_BOX)
	place_objective(AMMO_BOX)
	# punch
	place_objective(FRUIT_PUNCH_BOWL)
	#shops
	place_objective(SHOP_LMG)
	place_objective(SHOP_RIFLE)
	place_objective(SHOP_SHOTGUN)
	place_objective(SHOP_SMG)
	var player = PLAYER.instantiate()
	add_child(player)
	player.global_transform.origin = player_spawn_point.global_position
	var aim_ret = AIM_RETICLE.instantiate()
	add_child(aim_ret)
	var ui = PLAYER_UI.instantiate()
	add_child(ui)
	var pause_menu = PAUSE_MENU.instantiate()
	add_child(pause_menu)

func place_objective(prototype_scene) -> Node3D:
	var objective = prototype_scene.instantiate()
	add_child(objective)
	objective.global_transform.origin = obj_spawns[index].global_position
	index += 1
	return objective
