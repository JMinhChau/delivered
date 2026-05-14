extends Node2D

const DAY_INVENTORY = {
	1: {"vegetables": 1, "sweets": 1},
	2: {"vegetables": 1, "sweets": 1, "flour": 1},
	3: {"vegetables": 1, "sweets": 1, "flour": 1},
	4: {"vegetables": 1, "sweets": 1, "flour": 1, "oranges": 1},
	5: {"vegetables": 1, "sweets": 1, "flour": 1, "oranges": 1},
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
		{"speaker": "Mr. Gus", "text": "You."},
		{"speaker": "Mr. Gus", "text": "You're K's sibling?"},
		{"speaker": "Mr. Gus", "text": "You have his ears."},
		{"speaker": "You", "text": "I'm only—"},
		{"speaker": "Mr. Gus", "text": "Parcels are in the back. Two stops."},
		{"speaker": "Mr. Gus", "text": "Don't crash the truck."},
		{"speaker": "Mr. Gus", "text": "Go."},
	],
	2: {
		"good": [
			{"speaker": "Mr. Gus", "text": "Back."},
			{"speaker": "Mr. Gus", "text": "Nobody's called to complain."},
			{"speaker": "Mr. Gus", "text": "Three stops today. One's new."},
			{"speaker": "Mr. Gus", "text": "Benne. She has opinions."},
			{"speaker": "Mr. Gus", "text": "Don't engage."},
		],
		"bad": [
			{"speaker": "Mr. Gus", "text": "Back."},
			{"speaker": "Mr. Gus", "text": "How many parcels did you drop."},
			{"speaker": "You", "text": "Some of them—"},
			{"speaker": "Mr. Gus", "text": "Three stops today."},
			{"speaker": "Mr. Gus", "text": "Deliver at least one."},
		],
	},
	3: [
		{"speaker": "Mr. Gus", "text": "K called again."},
		{"speaker": "Mr. Gus", "text": "'Still sick.'"},
		{"speaker": "Mr. Gus", "text": "He's not sick."},
		{"speaker": "Mr. Gus", "text": "Same three stops."},
		{"speaker": "Mr. Gus", "text": "There's a hole in the road now."},
		{"speaker": "Mr. Gus", "text": "It was there before you."},
		{"speaker": "Mr. Gus", "text": "Go."},
	],
	4: [
		{"speaker": "Mr. Gus", "text": "K says he'll be back tomorrow."},
		{"speaker": "Mr. Gus", "text": "Four stops. One new: Lou."},
		{"speaker": "Mr. Gus", "text": "Lou and K have history."},
		{"speaker": "Mr. Gus", "text": "Unrelated: don't mention K."},
		{"speaker": "Mr. Gus", "text": "Go."},
	],
	5: [
		{"speaker": "Mr. Gus", "text": "Last day."},
		{"speaker": "Mr. Gus", "text": "Four stops."},
		{"speaker": "You", "text": "Did K say anything about—"},
		{"speaker": "Mr. Gus", "text": "I texted him."},
		{"speaker": "Mr. Gus", "text": "Told him you were adequate."},
		{"speaker": "You", "text": "Is that good?"},
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
