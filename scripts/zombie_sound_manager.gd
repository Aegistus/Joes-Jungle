extends Node

@export var min_bark_interval = 5
@export var max_bark_interval = 30

@onready var bark_audio_player = $BarkAudioPlayer
@onready var attack_audio_player = $AttackAudioPlayer
@onready var hit_audio_player = $HitAudioPlayer
@onready var death_audio_player = $DeathAudioPlayer
@onready var bark_timer = $BarkTimer
@onready var state_machine = $"../StateMachine"
@onready var dead_state = $"../StateMachine/DeadState"

func _ready():
	state_machine.on_state_change.connect(check_state)
	bark_timer.timeout.connect(play_bark)
	play_bark()
	dead_state.on_zombie_death.connect(func(): bark_timer.stop())

func check_state(state : State):
	if state is AttackState:
		attack_audio_player.play()
	elif state is HitState:
		hit_audio_player.play()
	elif state is DeadState:
		death_audio_player.play()

func play_bark():
	bark_audio_player.play()
	randomize()
	bark_timer.wait_time = randf_range(min_bark_interval, max_bark_interval)
	bark_timer.start()
