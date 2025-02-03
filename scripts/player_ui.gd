extends Control

@onready var interactable_tooltip = $CanvasLayer/InteractableTooltip
@onready var health_bar = $CanvasLayer/HealthBar

var player

func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	player.health_update.connect(func(health, health_max): health_bar.value = health / health_max * 100)
	health_bar.value = 100

func _process(delta):
	if player.current_interactable != null:
		interactable_tooltip.visible = true
	else:
		interactable_tooltip.visible = false
