class_name WateringBush
extends Node3D

@export var max_water = 100.0
@export var water_loss_rate = 10.0

@onready var watering_bush = $SubViewport/WateringBush
@onready var watering_sound = $WateringSound

var current_water: float:
	set(value):
		current_water = value
		watering_bush.set_progress_bar(current_water / max_water * 100.0)

func _ready():
	current_water = max_water

func _process(delta):
	if (current_water > 0):
		current_water -= water_loss_rate * delta
		if current_water <= 0:
			current_water = 0
			GameManager.end_game()

func water(amount):
	if current_water < max_water:
		current_water += amount
		if !watering_sound.playing:
			watering_sound.play()
