extends Emplacement

@onready var animation_player = %AnimationPlayer

func place():
	animation_player.play("place")
