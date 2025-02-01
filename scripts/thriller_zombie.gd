extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Thriller Anims/Thriller 1")

func _on_animation_player_animation_finished(anim_name):
	var next_anim = ""
	match anim_name:
		"Thriller Anims/Thriller 1":
			next_anim = "Thriller Anims/Thriller 2"
		"Thriller Anims/Thriller 2":
			next_anim = "Thriller Anims/Thriller 3"
		"Thriller Anims/Thriller 3":
			next_anim = "Thriller Anims/Thriller 4"
		_:
			next_anim = "Thriller Anims/Thriller 1"
	animation_player.play(next_anim)
