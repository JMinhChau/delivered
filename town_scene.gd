extends Node2D

const NPC_ITEM = {
	"Momo": "vegetables",
	"Pip": "sweets",
	"Benne": "flour",
}

const NPC_PITCH = {
	"Momo": 1.3,
	"Pip": 0.85,
	"Benne": 0.65,
}

const DIALOGUE = {
	"Momo": [
		# variant 0: delivered
		["Oh! The groceries!", "You must be K's sibling.", "Same ears. Same nervous eyes.", "Tell him I said hi."],
		# variant 1: nothing
		["No vegetables today?", "That's fine, dear.", "Tell K to feel better."],
	],
	"Pip": [
		# variant 0: delivered
		["Ayy the delivery!", "Hey... are you even old enough to drive?", "Same. I'm also not supposed to be here.", "We're good."],
		# variant 1: nothing
		["No sweets today? Relatable.", "I also forgot what I was doing.", "Cool. Neither of us was here."],
	],
	"Benne": [
		# variant 0: delivered
		["Finally.", "I've been waiting three days for this flour.", "You look young.", "No offense. Just an observation."],
		# variant 1: nothing
		["No flour?", "Interesting.", "The flour situation continues."],
	],
}

var visited = []
var current_npc = ""
var current_lines = []
var current_line_idx = 0
var pending_item_key = ""
var _type_full = ""
var _type_index = 0
var _is_typing = false
var _current_pitch = 1.0

@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
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

func _start_typing(text: String, pitch: float = 1.0):
	_type_full = text
	_type_index = 0
	_is_typing = true
	_current_pitch = pitch
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
	current_lines = DIALOGUE[npc_name][variant]
	current_line_idx = 0
	dialogue_box.visible = true
	_start_typing(current_lines[0], NPC_PITCH[npc_name])

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
		_start_typing(current_lines[current_line_idx], NPC_PITCH[current_npc])
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
	GameState.drive_mode = "return"
	get_tree().change_scene_to_file("res://drive_scene.tscn")
