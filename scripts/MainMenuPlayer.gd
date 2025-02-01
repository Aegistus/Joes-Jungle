extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Zombie Anims/Zombie Death 1")
	animation_player.seek(4.4667, true)
	animation_player.pause()
