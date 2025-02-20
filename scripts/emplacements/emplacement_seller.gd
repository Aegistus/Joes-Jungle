class_name EmplacementSeller
extends Interactable

signal on_sell

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(func(): on_sell.emit())

func interact_start():
	timer.start()

func interact_end():
	timer.stop()
