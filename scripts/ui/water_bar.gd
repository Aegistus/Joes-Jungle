extends Control

@onready var progress_bar = $ProgressBar
@onready var name_label = $ProgressBar/NameLabel
@onready var scrap_amount = $ScrapAmount

var bush : WateringBush

func set_progress_bar(value):
	progress_bar.value = value

func _process(delta):
	scrap_amount.text = str(bush.stored_scrap)
