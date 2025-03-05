@tool
extends HBoxContainer

var undo_redo : EditorUndoRedoManager

func _on_x_rotate_button_pressed():
	var selection = EditorInterface.get_selection()
	var angle = %XSpinBox.value
	undo_redo.create_action("Rotation Randomizer: Rotate X")
	for node in selection.get_selected_nodes():
		if node is Node3D:
			var random_rotation = randf_range(0, deg_to_rad(angle))
			var rotation = node.rotation
			rotation.x = fposmod(node.rotation.x + random_rotation, PI * 2)
			undo_redo.add_do_property(node, "rotation", rotation)
			undo_redo.add_undo_property(node, "rotation", node.rotation)
	undo_redo.commit_action(true)


func _on_y_rotate_button_pressed():
	var selection = EditorInterface.get_selection()
	var angle = %YSpinBox.value
	undo_redo.create_action("Rotation Randomizer: Rotate Y")
	for node in selection.get_selected_nodes():
		if node is Node3D:
			var random_rotation = randf_range(0, deg_to_rad(angle))
			var rotation = node.rotation
			rotation.y = fposmod(node.rotation.y + random_rotation, PI * 2)
			undo_redo.add_do_property(node, "rotation", rotation)
			undo_redo.add_undo_property(node, "rotation", node.rotation)
	undo_redo.commit_action(true)


func _on_z_rotate_button_pressed():
	var selection = EditorInterface.get_selection()
	var angle = %ZSpinBox.value
	undo_redo.create_action("Rotation Randomizer: Rotate Z")
	for node in selection.get_selected_nodes():
		if node is Node3D:
			var random_rotation = randf_range(0, deg_to_rad(angle))
			var rotation = node.rotation
			rotation.z = fposmod(node.rotation.z + random_rotation, PI * 2)
			undo_redo.add_do_property(node, "rotation", rotation)
			undo_redo.add_undo_property(node, "rotation", node.rotation)
	undo_redo.commit_action(true)
