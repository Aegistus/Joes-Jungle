extends Node

var infected_zombie_mat = preload("res://materials/infected_zombie_mat.tres")

func _process(delta):
	infected_zombie_mat.albedo_color.a = GameManager.current_insanity
