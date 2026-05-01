extends Node2D

const DAY_INVENTORY = {
	1: {"vegetables": 1, "sweets": 1},
	2: {"vegetables": 1, "sweets": 1, "flour": 1},
	3: {"vegetables": 2, "sweets": 1, "flour": 2},
}

const DAY_NPCS = {
	1: ["Momo", "Pip"],
	2: ["Momo", "Pip", "Benne"],
	3: ["Momo", "Pip", "Benne"],
}

const DIALOGUE = {
	1: [
		"You. Parcels are in the back.",
		"Don't take the main road.",
		"I didn't say that.",
	],
	2: {
		"good": [
			"Back. Fine.",
			"Yesterday was... acceptable.",
			"Same deal.",
		],
		"bad": [
			"Back.",
			"Lost most of them, didn't you.",
			"Try harder.",
		],
	},
	3: [
		"Last day.",
		"K owes me one.",
		"You owe him too. For the opportunity.",
		"Don't make me regret this.",
	],
}

const VOICE_PITCH = 0.55

var lines = []
var line_index = 0
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_text = $DialogueBox/DialogueText
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer

func _ready():
	GameState.inventory = DAY_INVENTORY[GameState.day].duplicate()
	GameState.active_npcs = DAY_NPCS[GameState.day].duplicate()
	GameState.items = GameState.inventory.values().reduce(func(a, b): return a + b, 0)

	if GameState.day == 2:
		var variant = "good" if GameState.last_delivered >= 1 else "bad"
		lines = DIALOGUE[2][variant]
	else:
		lines = DIALOGUE[GameState.day]

	type_timer.timeout.connect(_on_type_tick)
	_start_typing(lines[0], VOICE_PITCH)

func _start_typing(text: String, pitch: float = 1.0):
	_type_full = text
	_type_index = 0
	_is_typing = true
	voice_player.pitch_scale = pitch
	dialogue_text.text = ""
	type_timer.start()

func _on_type_tick():
	if _type_index < _type_full.length():
		_type_index += 1
		dialogue_text.text = _type_full.substr(0, _type_index)
		var ch = _type_full[_type_index - 1]
		if ch != " " and ch != "\n":
			voice_player.play()
	else:
		_is_typing = false
		type_timer.stop()

func _unhandled_input(event):
	if not event.is_action_pressed("ui_accept"):
		return
	if _is_typing:
		dialogue_text.text = _type_full
		_is_typing = false
		type_timer.stop()
		return
	line_index += 1
	if line_index >= lines.size():
		get_tree().change_scene_to_file("res://drive_scene.tscn")
	else:
		_start_typing(lines[line_index], VOICE_PITCH)
