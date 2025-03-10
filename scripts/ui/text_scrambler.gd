extends Control

var scramble_chance = 1
var unscrambled_labels : Array[Label]

func _ready():
	get_parent().visibility_changed.connect(on_show)
	var all_children = get_all_children(self)
	for child in all_children:
		if child is Label:
			unscrambled_labels.append(child)

func on_show():
	var remove_indexes : Array[int]
	for i in unscrambled_labels.size():
		var chance = randf()
		if chance < scramble_chance:
			scramble_label(unscrambled_labels[i])
			remove_indexes.append(i)
	remove_indexes.reverse()
	#for i in remove_indexes:
		#unscrambled_labels.remove_at(i)

func scramble_label(label : Label):
	var starting_text = label.text
	var scrambled_text = ""
	var substrings = starting_text.split(" ")
	for i in substrings.size():
		scrambled_text += scramble(substrings[i])
		if i < substrings.size() - 1:
			scrambled_text += " "
	label.text = scrambled_text

func scramble(text : String) -> String:
	if text.length() < 4:
		return text
	var i = 1
	while i < text.length() - 1:
		var temp = text[i]
		text[i] = text[i + 1]
		text[i + 1] = temp
		i += 2
	return text

func get_all_children(node) -> Array:
	var nodes : Array = []
	for n in node.get_children():
		nodes.append(n)
		if n.get_child_count() > 0:
			nodes.append_array(get_all_children(n))
	return nodes
