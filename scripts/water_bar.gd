extends Control

@onready var progress_bar = $ProgressBar

func set_progress_bar(value):
	progress_bar.value = value
