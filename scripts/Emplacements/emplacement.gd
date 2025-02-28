class_name Emplacement
extends Node3D

@export var stats_path : String

@onready var emplacement_overlapper = %EmplacementOverlapper as Area3D

var stats : EmplacementStats

func _ready():
	stats = load(stats_path)
	GameManager.on_wave_end.connect(place)

func place():
	pass

func sell():
	GameManager.add_scrap(stats.cost)
	queue_free()

func destroy():
	pass
