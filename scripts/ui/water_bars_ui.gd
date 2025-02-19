extends VBoxContainer

@export var default_color : Color
@export var warning_color : Color
@export var plant_progress_bars : Array[ProgressBar]

var watering_bushes : Array[WateringBush] = [null, null, null]

var plant_low : Array[bool] = [false,false,false]

var defaultStyleBox : StyleBoxFlat
var warningStyleBox : StyleBoxFlat

func _ready():
	defaultStyleBox = StyleBoxFlat.new()
	defaultStyleBox.bg_color = default_color
	warningStyleBox = StyleBoxFlat.new()
	warningStyleBox.bg_color = warning_color
	var all_plants = get_tree().get_nodes_in_group("plant")
	for i in all_plants.size():
		match (all_plants[i].id):
			0: watering_bushes[0] = all_plants[i] as WateringBush
			1: watering_bushes[1] = all_plants[i] as WateringBush
			2: watering_bushes[2] = all_plants[i] as WateringBush

func _process(delta):
	for i in watering_bushes.size():
		update_bush_ui(i)

func update_bush_ui(i : int):
	plant_progress_bars[i].value = watering_bushes[i].current_water / watering_bushes[i].max_water * 100
	if watering_bushes[i].current_water <= watering_bushes[i].max_water / 2.0 and !plant_low[i]:
		plant_low[i] = true
		plant_progress_bars[i].add_theme_stylebox_override("fill", warningStyleBox)
	if watering_bushes[i].current_water > watering_bushes[i].max_water / 2.0 and plant_low[i]:
		plant_low[i] = false
		plant_progress_bars[i].add_theme_stylebox_override("fill", defaultStyleBox)
