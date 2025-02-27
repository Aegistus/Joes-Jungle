extends Label

@export var add_color : Color
@export var subtract_color : Color

@onready var scrap_change = $ScrapChange

var hide_additional_scrap = 0

var current_scrap: int = 0:
	set(value):
		update_ui(value)
		current_scrap = value
	get:
		return current_scrap

func _ready():
	GameManager.on_scrap_change.connect(update_scrap)
	scrap_change.visible = false

func update_scrap(new_scrap_amount, additional_scrap):
	update_points_change(additional_scrap)
	var tween = create_tween()
	tween.tween_property(self, "current_scrap", new_scrap_amount, .25)

func update_ui(value):
	text = str("Joe Scrap ", value)

func update_points_change(additional_scrap):
	var sign = "+" if additional_scrap >= 0 else "-"
	var color = add_color if additional_scrap >= 0 else subtract_color
	scrap_change.text = sign + "$" + str(abs(additional_scrap))
	scrap_change.add_theme_color_override("font_color", color)
	scrap_change.visible = true
	hide_additional_scrap += 1
	await get_tree().create_timer(2).timeout
	hide_additional_scrap -= 1
	if hide_additional_scrap <= 0:
		scrap_change.visible = false
