extends Control

@onready var water_plant_tip = $CanvasLayer/WaterPlantTip
@onready var health_bar = $CanvasLayer/HealthBar

var player

func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	player.health_update.connect(func(health, max): health_bar.value = health / max * 100)
	health_bar.value = 100

func _process(delta):
	if player.current_plant != null:
		water_plant_tip.visible = true
	else:
		water_plant_tip.visible = false
