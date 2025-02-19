extends Panel

func _ready():
	GameManager.on_wave_start.connect(func(): visible = false)
	GameManager.on_wave_end.connect(func(): visible = true)
