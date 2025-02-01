extends AudioStreamPlayer

func _ready():
	finished.connect(func(): play())
