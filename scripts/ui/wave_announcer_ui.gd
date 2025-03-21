extends Control

@export var start_scale := 10
@export var animation_time := 1.0
@export var fade_in_time := .5
@export var fade_out_time := 3
@export var font_color : Color

@onready var label : Label = $Label
@onready var clock_gong_audio_player = $ClockGongAudioPlayer
@onready var zombie_noise_audio_player = $ZombieNoiseAudioPlayer

func _ready():
	label.visible = false
	GameManager.on_wave_start.connect(announce_wave)
	GameManager.on_wave_start.connect(play_starting_sounds)

func announce_wave():
	label.text = "Wave " + str(GameManager.current_wave)
	label.modulate.a = .5
	label.scale = Vector2(start_scale, start_scale)
	label.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(label, "scale", Vector2.ONE, animation_time)
	tween.parallel().tween_property(label, "modulate:a", 1, fade_in_time)
	tween.tween_interval(2)
	tween.tween_property(label, "modulate:a", 0, fade_out_time)

func play_starting_sounds():
	var tween = get_tree().create_tween()
	tween.tween_interval(1)
	zombie_noise_audio_player.play()
	tween.set_loops(GameManager.current_wave)
	tween.tween_interval(2.5)
	tween.tween_callback(clock_gong_audio_player.play)
