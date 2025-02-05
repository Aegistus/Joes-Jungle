extends VBoxContainer

@onready var entry_hall_prog = $HBoxContainer/ProgressBar
@onready var kitchen_prog = $HBoxContainer2/ProgressBar
@onready var patio_prog = $HBoxContainer3/ProgressBar

var entry_plant : WateringBush
var kitchen_plant : WateringBush
var patio_plant : WateringBush

func _ready():
	var all_plants = get_tree().get_nodes_in_group("plant")
	for i in all_plants.size():
		match (all_plants[i].location):
			WateringBush.HouseLocation.ENTRY:
				entry_plant = all_plants[i]
			WateringBush.HouseLocation.KITCHEN:
				kitchen_plant = all_plants[i]
			WateringBush.HouseLocation.PATIO:
				patio_plant = all_plants[i]

func _process(delta):
	entry_hall_prog.value = entry_plant.current_water / entry_plant.max_water * 100
	kitchen_prog.value = kitchen_plant.current_water / kitchen_plant.max_water * 100
	patio_prog.value = patio_plant.current_water / patio_plant.max_water * 100
