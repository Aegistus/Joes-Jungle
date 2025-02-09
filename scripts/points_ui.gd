extends Label

@export var add_color : Color
@export var subtract_color : Color

@onready var points_change = $PointsChange

var hide_additional_points = 0

var current_points: int = 0:
	set(value):
		update_ui(value)
		current_points = value
	get:
		return current_points

func _ready():
	GameManager.on_point_change.connect(update_points)
	points_change.visible = false

func update_points(new_points_amount, additional_points):
	update_points_change(additional_points)
	var tween = create_tween()
	tween.tween_property(self, "current_points", new_points_amount, .25)

func update_ui(value):
	text = str("Joe Bucks $", value)

func update_points_change(additional_points):
	var sign = "+" if additional_points >= 0 else "-"
	var color = add_color if additional_points >= 0 else subtract_color
	points_change.text = sign + "$" + str(abs(additional_points))
	points_change.add_theme_color_override("font_color", color)
	points_change.visible = true
	hide_additional_points += 1
	await get_tree().create_timer(2).timeout
	hide_additional_points -= 1
	if hide_additional_points <= 0:
		points_change.visible = false
