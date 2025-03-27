extends Node3D

@export var spawn_objectives = true

const WATERING_BUSH = preload("res://scenes/watering_bush.tscn")
const AMMO_BOX = preload("res://scenes/shops/ammo_box.tscn")
const FRUIT_PUNCH_BOWL = preload("res://scenes/shops/fruit_punch_bowl.tscn")
const SHOP_SAW = preload("res://scenes/shops/shop_saw.tscn")
const SHOP_M4 = preload("res://scenes/shops/shop_m4A1.tscn")
const SHOP_AK_47 = preload("res://scenes/shops/shop_ak47.tscn")
const SHOP_BENELLI = preload("res://scenes/shops/shop_benelli.tscn")
const SHOP_AA_12 = preload("res://scenes/shops/shop_aa12.tscn")
const SHOP_UZI = preload("res://scenes/shops/shop_uzi.tscn")
const SHOP_MPX = preload("res://scenes/shops/shop_mpx.tscn")
const SHOP_FLAMETHROWER = preload("res://scenes/shops/shop_flamethrower.tscn")
const SHOP_SAURUS = preload("res://scenes/shops/shop_revolver.tscn")
const PLAYER = preload("res://scenes/player.tscn")
const PLAYER_UI = preload("res://scenes/ui/player_ui.tscn")
const PAUSE_MENU = preload("res://scenes/ui/pause_menu.tscn")

@onready var objective_spawn_points_parent = $ObjectiveSpawnPointsParent
@onready var player_spawn_point = $PlayerSpawnPoint

var obj_spawns
var index = -1

func _ready():
	if not GameManager.is_game_running:
		GameManager.start_game()
	if spawn_objectives:
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
		place_objective(SHOP_SAW)
		place_objective(SHOP_M4)
		place_objective(SHOP_AK_47)
		place_objective(SHOP_BENELLI)
		place_objective(SHOP_AA_12)
		place_objective(SHOP_MPX)
		place_objective(SHOP_UZI)
		place_objective(SHOP_FLAMETHROWER)
		place_objective(SHOP_SAURUS)
	var player = PLAYER.instantiate()
	add_child(player)
	player.global_transform.origin = player_spawn_point.global_position
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
