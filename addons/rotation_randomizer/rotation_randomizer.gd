@tool
extends EditorPlugin

var panel

const TOOL_PANEL = preload("res://addons/rotation_randomizer/tool_panel.tscn")

func _enter_tree():
	panel = TOOL_PANEL.instantiate()
	panel.undo_redo = get_undo_redo()
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, panel)

func _exit_tree():
	remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, panel)
	panel.queue_free()
