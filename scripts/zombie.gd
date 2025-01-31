extends CharacterBody3D

@export var starting_health = 10

var current_health

func _ready():
	current_health = starting_health

func hit(damage):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		print("I'm dead")
	print(current_health)
