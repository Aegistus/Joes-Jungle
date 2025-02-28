extends Control

@export var selected_border_width = 1

@onready var build_item_name = $BuildItemName
@onready var build_item_cost = $BuildItemCost
@onready var build_options_container = $BuildOptions/BuildOptionsContainer

var build_gun : BuildGun

func _ready():
	visible = false
	build_gun = (get_tree().get_first_node_in_group("player") as Player).build_gun
	build_gun.on_equip.connect(show_menu)
	build_gun.on_unequip.connect(func(): visible = false)
	build_gun.on_change_selected_build.connect(select_option)

func show_menu():
	visible = true
	select_option(build_gun.current_index)

func select_option(index : int):
	build_item_name.text = build_gun.current_emplacement.name
	build_item_cost.text = str(build_gun.current_emplacement.cost)
	var options = build_options_container.get_children()
	for i in options.size():
		var option = options[i] as Panel
		var style : StyleBoxFlat = option.get_theme_stylebox("panel")
		if i == index:
			style.border_width_top = selected_border_width
			style.border_width_bottom = selected_border_width
			style.border_width_left = selected_border_width
			style.border_width_right = selected_border_width
		else:
			style.border_width_top = 0
			style.border_width_bottom = 0
			style.border_width_left = 0
			style.border_width_right = 0
