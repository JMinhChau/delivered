extends Node2D

const	DIALOGUE = [
	["Another day, another delivery.", "5 packages. Don't lose them.", "And don't even think about shortcuts."],
	["You're back. Fine.", "5 more packages. Same rules.", "Don't embarrass me."],
	["Last day.", "5 packages.", "Try not to lose them all this time."],
]

var lines = []
var line_index = 0

@onready var dialogue_text = $DialogueBox/DialogueText

func _ready():
	GameState.items = 5
	lines = DIALOGUE[GameState.day - 1]
	dialogue_text.text = lines[0]
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		line_index += 1
		if line_index >= lines.size():
			get_tree().change_scene_to_file("res://drive_scene.tscn")
		else:
			dialogue_text.text = lines[line_index]
