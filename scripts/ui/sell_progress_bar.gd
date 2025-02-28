extends Control

@onready var texture_progress_bar = $TextureProgressBar

var player : Player
var emplacement : EmplacementSeller

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player.current_interactable != null and player.current_interactable is EmplacementSeller:
		if !visible:
			visible = true
		if player.current_interactable != emplacement:
			emplacement = player.current_interactable as EmplacementSeller
		if emplacement:
			if emplacement.timer.is_stopped():
				texture_progress_bar.value = 0
			else:
				texture_progress_bar.value = (emplacement.timer.wait_time - emplacement.timer.time_left) / emplacement.timer.wait_time
	elif visible:
		visible = false
