extends Node

enum CauseOfDeath { ZOMBIE, PLANT }

signal on_point_change(current_points, added_points)
signal on_scrap_change(current_scrap, added_scrap)
signal on_zombie_kill
signal on_wave_start
signal on_wave_end
signal on_intermission_start
signal on_intermission_end
signal on_barricade_added(barricade : Node3D)
signal on_barricade_destroyed
signal on_killstreak_updated(current_killstreak)

const SAVE_FILE_PATH = "user://savegame.dat"
const BUCKS_PER_KILLSTREAK_KILL = 10

var currently_in_wave = false
var current_wave : int = 0
var run_time = 0.0
var current_points = 0
var current_scrap = 0
var is_game_running = false
var current_killstreak = 0

var cause_of_death : CauseOfDeath
var zombie_death_text : Array[String] = ["Being Too Tasty for Your Own Good",\
 "Having a Brain that Brings All the Zombies to the Yard",\
"Trying to Befriend the Zombies Instead of Killing Them",\
"Kissing a Zombie and Getting the Zombie Virus"]

var plant_death_text : Array[String] = ["Plant Neglect",\
"Forgetting to Pour One Out for the Homies",\
"Having a Brown Thumb",\
"Lack of an Environmental Conscience",\
"Failing to be a Responsible Plant Parent",\
"Soiling Your Pants (Instead of Your Plants)",\
"Stopping to Smell the Roses, Instead of Watering Them"]

@onready var intermission_timer : Timer = $IntermissionTimer
@onready var kill_streak_timer : Timer = $KillStreakTimer
@onready var skip_intermission_audio_player = $SkipIntermissionAudioPlayer

class GameRunEntry:
	var rank : int
	var player_name : String
	var time : float
	
	func _init(player_name : String, time : float):
		self.player_name = player_name
		self.time = time

var all_player_runs : Array[GameRunEntry]

func _ready():
	load_save_data()
	on_wave_start.connect(func(): currently_in_wave = true)
	on_wave_end.connect(func(): currently_in_wave = false)
	intermission_timer.timeout.connect(func(): on_intermission_end.emit())
	kill_streak_timer.timeout.connect(cash_out_killstreak)

func _process(delta):
	if is_game_running:
		run_time += delta
	if Input.is_action_just_pressed("skip_intermission") and !currently_in_wave:
		skip_intermission()

func start_game():
	run_time = 0
	current_points = 0
	current_scrap = 0
	is_game_running = true

func end_game(cause_of_death : CauseOfDeath):
	self.cause_of_death = cause_of_death
	is_game_running = false
	if all_player_runs == null:
		all_player_runs = []
	var inserted = false
	for i in all_player_runs.size():
		if all_player_runs[i] != null and run_time > all_player_runs[i].time:
			all_player_runs.insert(i, GameRunEntry.new("Player", run_time))
			inserted = true
			break
	if !inserted:
		all_player_runs.append(GameRunEntry.new("Player", run_time))
	set_run_rankings()
	save()
	get_tree().change_scene_to_file.bind("res://scenes/game_scenes/game_over_scene.tscn").call_deferred()

func start_intermission(duration : float):
	intermission_timer.wait_time = duration
	intermission_timer.one_shot = true
	intermission_timer.start()
	on_intermission_start.emit()

func skip_intermission():
	intermission_timer.wait_time = 10
	intermission_timer.one_shot = true
	intermission_timer.start()
	skip_intermission_audio_player.play()

func add_to_killstreak():
	current_killstreak += 1
	kill_streak_timer.start()
	on_killstreak_updated.emit(current_killstreak)

func cash_out_killstreak():
	if current_killstreak > 2:
		add_points(current_killstreak * BUCKS_PER_KILLSTREAK_KILL)
	current_killstreak = 0
	on_killstreak_updated.emit(current_killstreak)

func add_points(amount):
	current_points += amount
	on_point_change.emit(current_points, amount)

func spend_points(amount):
	current_points -= amount
	on_point_change.emit(current_points, -amount)

func add_scrap(amount):
	current_scrap += amount
	on_scrap_change.emit(current_scrap, amount)

func spend_scrap(amount):
	current_scrap -= amount
	on_scrap_change.emit(current_scrap, -amount)

func get_cause_of_death_text() -> String:
	if cause_of_death == CauseOfDeath.ZOMBIE:
		return zombie_death_text.pick_random()
	else:
		return plant_death_text.pick_random()

func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	for i in all_player_runs.size():
		file.store_line(all_player_runs[i].player_name)
		file.store_float(all_player_runs[i].time)
	file.close()

func load_save_data():
	all_player_runs = []
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file != null:
		while not file.eof_reached():
			var player_name = file.get_line()
			var time = file.get_float()
			if player_name != "" and time != 0:
				all_player_runs.append(GameRunEntry.new(player_name, time))
		file.close()
	set_run_rankings()

func set_run_rankings():
	all_player_runs.sort_custom(compare_runs)
	for i in all_player_runs.size():
		all_player_runs[i].rank = i + 1

func compare_runs(run1 : GameRunEntry, run2 : GameRunEntry) -> bool:
	if run1.time > run2.time:
		return true
	else:
		return false
