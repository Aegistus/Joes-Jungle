extends Node3D

@export var enabled := true
@export var shell_particle_path := ""
@export var shell_scale := .013

var shell_particle_effect

func _ready():
	shell_particle_effect = load(shell_particle_path)

func eject():
	if enabled:
		var particle = shell_particle_effect.instantiate() as GPUParticles3D
		get_tree().current_scene.add_child(particle)
		particle.scale = Vector3(shell_scale, shell_scale, shell_scale)
		particle.global_position = global_position
		particle.global_rotation = global_rotation
		particle.emitting = true
