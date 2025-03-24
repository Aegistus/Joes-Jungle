extends Node3D

@onready var jungle_sounds = $JungleSounds
@onready var horror_ambiance = $HorrorAmbiance

var default_volume
var volume_decrease = -20
var transition_time = 1

func _ready():
	default_volume = jungle_sounds.volume_db

func _process(delta):
	horror_ambiance.volume_db = (1 - GameManager.current_linear_insanity) * -80

func on_player_enter(area):
	var tween = get_tree().create_tween()
	tween.tween_property(jungle_sounds, "volume_db", default_volume - 10, transition_time)

func on_player_exit(area):
	var tween = get_tree().create_tween()
	tween.tween_property(jungle_sounds, "volume_db", default_volume, transition_time)
