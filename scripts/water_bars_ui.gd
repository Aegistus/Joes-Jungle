extends VBoxContainer

@onready var plant_a_prog = $HBoxContainer/ProgressBar
@onready var plant_b_prog = $HBoxContainer2/ProgressBar
@onready var plant_c_prog = $HBoxContainer3/ProgressBar

var plant_a : WateringBush
var plant_b : WateringBush
var plant_c : WateringBush

func _ready():
	var all_plants = get_tree().get_nodes_in_group("plant")
	for i in all_plants.size():
		match (all_plants[i].id):
			0: plant_a = all_plants[i]
			1: plant_b = all_plants[i]
			2: plant_c = all_plants[i]

func _process(delta):
	plant_a_prog.value = plant_a.current_water / plant_a.max_water * 100
	plant_b_prog.value = plant_b.current_water / plant_b.max_water * 100
	plant_c_prog.value = plant_c.current_water / plant_c.max_water * 100
