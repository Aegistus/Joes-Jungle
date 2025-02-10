extends GPUParticles3D

@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func _process(delta):
	if not emitting:
		queue_free()

func _on_timer_timeout():
	audio_stream_player_3d.play()
