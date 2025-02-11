extends Panel

var last_health : float
var inner_radius: float:
	set(value):
		inner_radius = value
		update_shader()

var clear_radius = 1
var hit_radius_value = .3

func _ready():
	var player = get_tree().get_first_node_in_group("player") as Player
	player.health_update.connect(on_health_change)
	last_health = player.max_health
	material.set("shader_parameter/inner_radius", clear_radius)

func on_health_change(new_health, max_health):
	if new_health < last_health:
		last_health = new_health
		inner_radius = hit_radius_value
		var tween = create_tween()
		tween.tween_property(self, "inner_radius", clear_radius, 1)
		print(material.get("shader_parameter/inner_radius"))
		print(material.get("shader_parameter/outer_radius"))

func update_shader():
	material.set("shader_parameter/inner_radius", inner_radius)
