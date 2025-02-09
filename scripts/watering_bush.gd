class_name WateringBush
extends Interactable

@export var id : int
@export var max_water = 120.0
@export var water_loss_rate = 1.0
@export var water_increase_rate = 30.0

@onready var watering_bush = $SubViewport/WateringBush
@onready var watering_sound = $WateringSound

var current_water: float:
	set(value):
		current_water = value
		watering_bush.set_progress_bar(current_water / max_water * 100.0)

func _ready():
	current_water = max_water
	var letter
	if id == 0:
		letter = "A"
	elif id == 1:
		letter = "B"
	else:
		letter = "C"
	watering_bush.label.text = letter

func _process(delta):
	if (current_water > 0):
		current_water -= water_loss_rate * delta
		if current_water <= 0:
			current_water = 0
			GameManager.end_game(GameManager.CauseOfDeath.PLANT)

func interact_during(delta):
	if current_water < max_water:
		current_water += delta * water_increase_rate
		if !watering_sound.playing:
			watering_sound.play()
