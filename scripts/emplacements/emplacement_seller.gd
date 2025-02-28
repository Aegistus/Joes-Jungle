class_name EmplacementSeller
extends Interactable

signal on_sell

@export var wave_sell_delay = 5
@export var intermission_sell_delay = 1

@onready var timer : Timer = $Timer

func _ready():
	timer.timeout.connect(func(): on_sell.emit())
	timer.wait_time = intermission_sell_delay
	GameManager.on_wave_start.connect(func(): timer.wait_time = wave_sell_delay)
	GameManager.on_intermission_start.connect(func(): timer.wait_time = intermission_sell_delay)

func interact_start():
	#if GameManager.currently_in_wave:
		#timer.wait_time = wave_sell_delay
	#else:
		#timer.wait_time = intermission_sell_delay
	timer.start()

func interact_end():
	timer.stop()
