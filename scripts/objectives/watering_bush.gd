class_name WateringBush
extends Interactable

@export var id : int
@export var max_water = 120.0
@export var water_loss_rate = 1.0
@export var water_increase_rate = 30.0
@export var scrap_per_tick := 10

@onready var water_bar = $SubViewport/WaterBar
@onready var watering_sound = $WateringSound
@onready var scrap_timer = $ScrapTimer

var current_water: float:
	set(value):
		current_water = value
		water_bar.set_progress_bar(current_water / max_water * 100.0)

var stored_scrap: int:
	get:
		var amount : int = ((int)(max_water - current_water) / (water_increase_rate * scrap_timer.wait_time)) * scrap_per_tick
		amount -= amount % scrap_per_tick
		return amount

func _ready():
	await get_tree().process_frame
	current_water = max_water
	var letter
	if id == 0:
		letter = "A"
	elif id == 1:
		letter = "B"
	else:
		letter = "C"
	water_bar.name_label.text = letter
	water_bar.bush = self
	scrap_timer.timeout.connect(func(): GameManager.add_scrap(scrap_per_tick))

func _process(delta):
	if (current_water > 0):
		current_water -= water_loss_rate * delta
		if current_water <= 0:
			current_water = 0
			GameManager.end_game(GameManager.CauseOfDeath.PLANT)

func interact_start():
	scrap_timer.start()

func interact_during(delta):
	if current_water < max_water:
		current_water += delta * water_increase_rate
		if !watering_sound.playing:
			watering_sound.play()
		if current_water > max_water:
			interact_end()

func interact_end():
	scrap_timer.stop()
