extends Control

var shake_rate = 100
var max_scramble_chance = 1
var scramble_chance:
	get:
		return GameManager.current_insanity * max_scramble_chance
var max_shake_level = 15
var current_shake_level:
	get:
		return GameManager.current_insanity * max_shake_level
var unscrambled_labels : Array[RichTextLabel]
var regex : RegEx

func _ready():
	get_parent().visibility_changed.connect(on_show)
	var all_children = get_all_children(self)
	for child in all_children:
		if child is RichTextLabel:
			(child as RichTextLabel).bbcode_enabled = true
			unscrambled_labels.append(child)
	regex = RegEx.new()
	regex.compile("\\[.*?\\]")

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

func scramble_label(label : RichTextLabel):
	var starting_text = regex.sub(label.text, "", true)
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
	while i < text.length() - 2:
		var temp = text[i]
		text[i] = text[i + 1]
		text[i + 1] = temp
		i += 2
	text = "[shake rate=" + str(shake_rate) + " level=" + str(current_shake_level) + "]" + text + "[/shake]"
	return text

func get_all_children(node) -> Array:
	var nodes : Array = []
	for n in node.get_children():
		nodes.append(n)
		if n.get_child_count() > 0:
			nodes.append_array(get_all_children(n))
	return nodes
