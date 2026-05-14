extends Node2D

const LINES = [
	{"speaker": "", "text": "Your brother K has a delivery job."},
	{"speaker": "", "text": "He does it every day. Rain or shine. Whatever."},
	{"speaker": "", "text": "This morning he texted you: 'cover for me? ur basically me'"},
	{"speaker": "", "text": "You are not basically him."},
	{"speaker": "", "text": "Also you have never driven a truck."},
	{"speaker": "", "text": "Details."},
]

var line_index = 0
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_text = $DialogueBox/DialogueText
@onready var speaker_label = $DialogueBox/SpeakerLabel
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer

func _ready():
	type_timer.timeout.connect(_on_type_tick)
	_start_typing(LINES[0])

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
	if line_index >= LINES.size():
		get_tree().change_scene_to_file("res://boss_scene.tscn")
	else:
		_start_typing(LINES[line_index])
