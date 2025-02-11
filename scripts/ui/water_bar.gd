extends Control

@onready var progress_bar = $ProgressBar
@onready var label = $ProgressBar/Label

func set_progress_bar(value):
	progress_bar.value = value
