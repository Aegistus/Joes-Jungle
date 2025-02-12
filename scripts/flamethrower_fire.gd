extends Node3D

@onready var flames = $Flames
@onready var smoke = $Smoke

func _ready():
	flames.emitting = false
	smoke.emitting = false

func play():
	flames.emitting = true
	smoke.emitting = true

func stop():
	flames.emitting = false
	smoke.emitting = false
