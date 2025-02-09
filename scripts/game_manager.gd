extends Node

enum CauseOfDeath { ZOMBIE, PLANT }

signal on_point_change(current_points, added_points)

var run_time = 0.0
var is_game_running = false

var current_points = 0

var cause_of_death :CauseOfDeath
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

func _process(delta):
	if is_game_running:
		run_time += delta

func start_game():
	run_time = 0
	current_points = 0
	is_game_running = true

func end_game(cause_of_death : CauseOfDeath):
	self.cause_of_death = cause_of_death
	is_game_running = false
	get_tree().change_scene_to_file("res://scenes/game_scenes/game_over_scene.tscn")

func add_points(amount):
	current_points += amount
	on_point_change.emit(current_points, amount)

func spend_points(amount):
	current_points -= amount
	on_point_change.emit(current_points, -amount)

func get_cause_of_death_text() -> String:
	if cause_of_death == CauseOfDeath.ZOMBIE:
		return zombie_death_text.pick_random()
	else:
		return plant_death_text.pick_random()
