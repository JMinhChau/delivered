extends Node2D

const DAY_INVENTORY = {
	1: {"vegetables": 1, "sweets": 1},
	2: {"vegetables": 1, "sweets": 1, "flour": 1},
	3: {"vegetables": 2, "sweets": 1, "flour": 2},
	4: {"vegetables": 2, "sweets": 2, "flour": 2, "oranges": 1},
	5: {"vegetables": 2, "sweets": 2, "flour": 2, "oranges": 2},
}

const DAY_NPCS = {
	1: ["Momo", "Pip"],
	2: ["Momo", "Pip", "Benne"],
	3: ["Momo", "Pip", "Benne"],
	4: ["Momo", "Pip", "Benne", "Lou"],
	5: ["Momo", "Pip", "Benne", "Lou"],
}

const DIALOGUE = {
	1: [
		{"speaker": "Mr. Gus", "text": "You. Parcels are in the back."},
		{"speaker": "Mr. Gus", "text": "Two stops. Don't take the main road."},
		{"speaker": "You", "text": "But I'm 14—"},
		{"speaker": "Mr. Gus", "text": "Did I ask."},
		{"speaker": "You", "text": "No sir."},
		{"speaker": "Mr. Gus", "text": "Good. Go."},
	],
	2: {
		"good": [
			{"speaker": "Mr. Gus", "text": "You're back."},
			{"speaker": "Mr. Gus", "text": "Yesterday was... acceptable."},
			{"speaker": "Mr. Gus", "text": "Three stops. New face on the list."},
			{"speaker": "Mr. Gus", "text": "She has opinions. That's your problem now."},
		],
		"bad": [
			{"speaker": "Mr. Gus", "text": "You're back."},
			{"speaker": "Mr. Gus", "text": "You dropped most of them."},
			{"speaker": "Mr. Gus", "text": "Try not to drop three."},
			{"speaker": "Mr. Gus", "text": "...two, at minimum."},
		],
	},
	3: [
		{"speaker": "Mr. Gus", "text": "K called again."},
		{"speaker": "Mr. Gus", "text": "Apparently he has 'a thing.'"},
		{"speaker": "Mr. Gus", "text": "Three stops. Same route."},
		{"speaker": "Mr. Gus", "text": "The road's gotten restless. Watch the middle lane."},
	],
	4: [
		{"speaker": "Mr. Gus", "text": "K's back tomorrow, he says."},
		{"speaker": "Mr. Gus", "text": "So."},
		{"speaker": "Mr. Gus", "text": "..."},
		{"speaker": "Mr. Gus", "text": "Four stops. Try not to make it weird."},
	],
	5: [
		{"speaker": "Mr. Gus", "text": "Last day."},
		{"speaker": "Mr. Gus", "text": "K comes in at noon."},
		{"speaker": "Mr. Gus", "text": "Four stops. Same route."},
		{"speaker": "You", "text": "Is there anything—"},
		{"speaker": "Mr. Gus", "text": "Go."},
	]
}

var lines = []
var line_index = 0
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_text = $DialogueBox/DialogueText
@onready var speaker_label = $DialogueBox/SpeakerLabel
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

	if GameState.day > 1:
		var overlay = $TransitionLayer/Overlay
		var day_label = $TransitionLayer/DayLabel
		day_label.text = "Day " + str(GameState.day)
		await get_tree().create_timer(0.8).timeout
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(overlay, "color:a", 0.0, 0.6)
		tween.tween_property(day_label, "modulate:a", 0.0, 0.4)
		await tween.finished
		$TransitionLayer.visible = false
	else:
		$TransitionLayer.visible = false

	_start_typing(lines[0])

func _start_typing(line: Dictionary):
	var spk = line.get("speaker", "")
	_type_full = line.get("text", "")
	_type_index = 0
	_is_typing = true
	speaker_label.text = spk
	speaker_label.visible = spk != ""
	voice_player.pitch_scale = GameState.SPEAKER_PITCH.get(spk, 1.0)
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
		_start_typing(lines[line_index])
