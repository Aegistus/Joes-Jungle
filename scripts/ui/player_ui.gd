extends Control

@onready var interactable_tooltip = $CanvasLayer/InteractableTooltip
@onready var tooltip_label = $CanvasLayer/InteractableTooltip/Label
@onready var health_bar = $CanvasLayer/DamageBar/HealthBar
@onready var damage_bar = $CanvasLayer/DamageBar

var player

func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	player.health_update.connect(update_health)
	health_bar.value = 100

func _process(delta):
	if player.current_interactable != null:
		interactable_tooltip.visible = true
		tooltip_label.text = player.current_interactable.tooltip_text
	else:
		interactable_tooltip.visible = false

func update_health(new_health, health_max):
	if float(new_health) / health_max > health_bar.value: # if healing
		var tween = create_tween()
		tween.tween_property(health_bar, "value", float(new_health) / health_max, 1)
		var tween2 = create_tween()
		tween2.tween_property(damage_bar, "value", float(new_health) / health_max, 1)
	else: # if taking damage
		health_bar.value = float(new_health) / health_max
		await get_tree().create_timer(.5).timeout
		var tween = create_tween()
		tween.tween_property(damage_bar, "value", float(new_health) / health_max, 1)
