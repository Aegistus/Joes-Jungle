extends Panel

@onready var label = $Label

func _ready():
	GameManager.on_point_change.connect(update_points)

func update_points(new_points_amount):
	label.text = str(" Points: ", new_points_amount)
