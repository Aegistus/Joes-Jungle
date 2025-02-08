class_name NoTargetState
extends ZombieState

@onready var animation_player = $"../../AnimationPlayer"

func enter():
	animation_player.play("Zombie Anims/Zombie Hit 1")
