extends Node2D

const NPC_ITEM = {
	"Momo": "vegetables",
	"Pip": "sweets",
	"Benne": "flour",
}

const DIALOGUE = {
	"Momo": {
		1: [
			[  # delivered
				{"speaker": "Momo", "text": "Oh! You actually came."},
				{"speaker": "Momo", "text": "I was starting to think K quit."},
				{"speaker": "Momo", "text": "You look just like him. Same ears. Same nervous eyes."},
				{"speaker": "Momo", "text": "Tell him I have extra soup when he's better."},
			],
			[  # not delivered
				{"speaker": "Momo", "text": "No vegetables. I see."},
				{"speaker": "Momo", "text": "I had a whole soup planned."},
				{"speaker": "Momo", "text": "Tell K I saved him soup anyway."},
			],
		],
		2: [
			[  # delivered
				{"speaker": "Momo", "text": "Back again."},
				{"speaker": "Momo", "text": "I thought yesterday might be a one-time thing."},
				{"speaker": "Momo", "text": "The soup was good, by the way."},
				{"speaker": "Momo", "text": "Tell K I said that."},
			],
			[  # not delivered
				{"speaker": "Momo", "text": "No vegetables again."},
				{"speaker": "Momo", "text": "Two days now."},
				{"speaker": "Momo", "text": "Tell K I'm adapting."},
			],
		],
		3: [
			[  # delivered
				{"speaker": "Momo", "text": "Third day."},
				{"speaker": "Momo", "text": "The soup's still going."},
				{"speaker": "Momo", "text": "I made extra."},
				{"speaker": "Momo", "text": "Don't tell anyone."},
			],
			[  # not delivered
				{"speaker": "Momo", "text": "No vegetables."},
				{"speaker": "Momo", "text": "I've stopped planning around it."},
				{"speaker": "Momo", "text": "Tell K the offer stands."},
			],
		],
	},
	"Pip": {
		1: [
			[  # delivered
				{"speaker": "Pip", "text": "There it is. Yes."},
				{"speaker": "Pip", "text": "Wait — how old are you?"},
				{"speaker": "Pip", "text": "You know what, don't answer that."},
				{"speaker": "Pip", "text": "I'll pretend I didn't see you. We're good."},
			],
			[  # not delivered
				{"speaker": "Pip", "text": "Nothing? Same."},
				{"speaker": "Pip", "text": "I don't even remember what I ordered."},
				{"speaker": "Pip", "text": "Cool. This conversation didn't happen."},
			],
		],
		2: [
			[  # delivered
				{"speaker": "Pip", "text": "You again."},
				{"speaker": "Pip", "text": "Okay."},
				{"speaker": "Pip", "text": "Still not asking. We're good."},
			],
			[  # not delivered
				{"speaker": "Pip", "text": "Nothing again."},
				{"speaker": "Pip", "text": "I've moved on. It's fine."},
				{"speaker": "Pip", "text": "This conversation is also not happening."},
			],
		],
		3: [
			[  # delivered
				{"speaker": "Pip", "text": "Three days."},
				{"speaker": "Pip", "text": "You're actually pretty consistent."},
				{"speaker": "Pip", "text": "Weird. But good."},
			],
			[  # not delivered
				{"speaker": "Pip", "text": "Nothing. Again."},
				{"speaker": "Pip", "text": "At least there's a pattern."},
				{"speaker": "Pip", "text": "I can work with a pattern."},
			],
		],
	},
	"Benne": {
		2: [
			[  # delivered
				{"speaker": "Benne", "text": "Finally."},
				{"speaker": "Benne", "text": "Do you know how long I've been waiting for this."},
				{"speaker": "Benne", "text": "You look twelve. No offense. Just an observation."},
			],
			[  # not delivered
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "..."},
				{"speaker": "Benne", "text": "The flour situation continues."},
			],
		],
		3: [
			[  # delivered
				{"speaker": "Benne", "text": "Third day."},
				{"speaker": "Benne", "text": "The flour is good."},
				{"speaker": "Benne", "text": "You're consistent. That's rare."},
			],
			[  # not delivered
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "Day three."},
				{"speaker": "Benne", "text": "I've adapted. Somewhat."},
			],
		],
	},
}

var visited = []
var current_npc = ""
var current_lines = []
var current_line_idx = 0
var pending_item_key = ""
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var speaker_label = $DialogueBox/SpeakerLabel
@onready var leave_button = $LeaveButton
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer

func _ready():
	type_timer.timeout.connect(_on_type_tick)
	for npc_name in ["Momo", "Pip", "Benne"]:
		var npc = get_node(npc_name)
		if npc_name in GameState.active_npcs:
			npc.input_event.connect(_on_npc_clicked.bind(npc_name))
			npc.visible = true
		else:
			npc.visible = false
	leave_button.pressed.connect(_on_leave)

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

func _on_npc_clicked(viewport, event, shape, npc_name):
	if not event is InputEventMouseButton or not event.pressed:
		return
	if npc_name in visited or current_npc != "":
		return

	current_npc = npc_name
	var item_key = NPC_ITEM[npc_name]
	var has_item = GameState.inventory.get(item_key, 0) > 0
	var variant = 0 if has_item else 1
	pending_item_key = item_key if has_item else ""
	current_lines = DIALOGUE[npc_name][GameState.day][variant]
	current_line_idx = 0
	dialogue_box.visible = true
	_start_typing(current_lines[0])

func _unhandled_input(event):
	if not event.is_action_pressed("ui_accept") or not dialogue_box.visible:
		return
	if _is_typing:
		dialogue_text.text = _type_full
		_is_typing = false
		type_timer.stop()
		return
	current_line_idx += 1
	if current_line_idx < current_lines.size():
		_start_typing(current_lines[current_line_idx])
	else:
		dialogue_box.visible = false
		if pending_item_key != "":
			GameState.inventory[pending_item_key] -= 1
			if GameState.inventory[pending_item_key] <= 0:
				GameState.inventory.erase(pending_item_key)
			GameState.items_delivered += 1
			pending_item_key = ""
		visited.append(current_npc)
		current_npc = ""
		if visited.size() == GameState.active_npcs.size():
			leave_button.visible = true

func _on_leave():
	get_tree().change_scene_to_file("res://salary_scene.tscn")
