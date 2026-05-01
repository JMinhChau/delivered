extends Node2D

const LINES = [
	"Your brother K called in sick.",
	"You offered to cover his shift.",
	"You: But I'm 14. I don't have a license.",
	"Mr. Gus: Did I ask?",
	"...",
	"Mr. Gus: 5 parcels. Town's not far. Mostly.",
]

const NARRATOR_PITCH = 1.0

var line_index = 0
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_text = $DialogueBox/DialogueText
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer

func _ready():
	type_timer.timeout.connect(_on_type_tick)
	_start_typing(LINES[0], NARRATOR_PITCH)

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
	if line_index >= LINES.size():
		get_tree().change_scene_to_file("res://boss_scene.tscn")
	else:
		_start_typing(LINES[line_index], NARRATOR_PITCH)
