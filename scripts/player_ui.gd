extends Control

@onready var water_plant_tip = $CanvasLayer/WaterPlantTip

var player

func _ready():
	player = get_tree().get_first_node_in_group("player") as Player

func _process(delta):
	if player.current_plant != null:
		water_plant_tip.visible = true
	else:
		water_plant_tip.visible = false
