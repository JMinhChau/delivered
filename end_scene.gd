extends Node2D

const BOSS_LINES = [
	{"speaker": "Mr. Gus", "text": "K's back Monday."},
	{"speaker": "Mr. Gus", "text": "Tell him—"},
	{"speaker": "Mr. Gus", "text": "—you did fine."},
	{"speaker": "Mr. Gus", "text": "Envelope's short."},
	{"speaker": "Mr. Gus", "text": "Training fee."},
	{"speaker": "Mr. Gus", "text": "Don't come back."},
	{"speaker": "Mr. Gus", "text": "(Unless K's sick again.)"},
]

const ENDING_GOOD = [
	{"speaker": "",    "text": "K is waiting outside."},
	{"speaker": "",    "text": "He looks fine. He was never sick."},
	{"speaker": "K",   "text": "You're back!"},
	{"speaker": "K",   "text": "Gus called."},
	{"speaker": "K",   "text": "He said you were adequate."},
	{"speaker": "K",   "text": "That's— he's never said that to me."},
	{"speaker": "",    "text": "..."},
	{"speaker": "You", "text": "You buying dinner?"},
	{"speaker": "",    "text": "You walk home."},
	{"speaker": "",    "text": "You let him think he's the better driver."},
]

const ENDING_NEUTRAL = [
	{"speaker": "",    "text": "K is waiting outside."},
	{"speaker": "",    "text": "He looks guilty."},
	{"speaker": "",    "text": "Good."},
	{"speaker": "K",   "text": "You're back."},
	{"speaker": "K",   "text": "Gus called. Job's still there. Barely."},
	{"speaker": "You", "text": "I tried."},
	{"speaker": "K",   "text": "I know. I saw the dents."},
	{"speaker": "You", "text": "...what dents."},
	{"speaker": "",    "text": "You walk home."},
	{"speaker": "",    "text": "Neither of you mention the dents."},
]

const ENDING_BAD = [
	{"speaker": "",    "text": "K is waiting outside."},
	{"speaker": "",    "text": "He already knows."},
	{"speaker": "K",   "text": "You're back."},
	{"speaker": "K",   "text": "Gus called. I'm fired."},
	{"speaker": "You", "text": "Sorry."},
	{"speaker": "K",   "text": "It's fine."},
	{"speaker": "K",   "text": "He said you drove like a 'natural disaster.'"},
	{"speaker": "You", "text": "...is that bad?"},
	{"speaker": "K",   "text": "Have fun?"},
	{"speaker": "You", "text": "...kind of."},
	{"speaker": "",    "text": "You walk home."},
	{"speaker": "",    "text": "He buys you ice cream."},
	{"speaker": "",    "text": "Brothers."},
]

const FACE_ART = {
	"Mr. Gus": "res://art/story/mr_gus_face.png",
	"K": "res://art/story/k_face.png",
	"You": "res://art/story/player_face.png",
}

var all_lines = []
var line_index = 0
var done = false
var transitioning = false
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_text = $DialogueBox/DialogueText
@onready var dialogue_box = $DialogueBox
@onready var speaker_label = $DialogueBox/SpeakerLabel
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer
@onready var ending_face = $EndingFace
@onready var ending_face_label = $EndingFace/FaceLabel
@onready var ending_face_sprite = $EndingFaceSprite
@onready var overlay = $TransitionLayer/Overlay
@onready var final_title = $FinalTitle

func _ready():
	ending_face_sprite.visible = false
	$TotalLabel.text = "Total: $" + str(GameState.money)
	$TotalLabel.visible = false
	$HighscoreLabel.visible = false
	final_title.visible = false
	$HighscoreLabel.text = "Km " + _km_text(GameState.total_km) + " / best " + _km_text(GameState.best_km)
	
	var ending_lines = ENDING_NEUTRAL
	if GameState.total_deliveries >= 12:
		ending_lines = ENDING_GOOD
	elif GameState.total_deliveries < 7:
		ending_lines = ENDING_BAD
		
	all_lines = BOSS_LINES + ending_lines
	type_timer.timeout.connect(_on_type_tick)
	overlay.color.a = 1.0
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, 0.8)
	_start_typing(all_lines[0])

func _start_typing(line: Dictionary):
	var spk = line.get("speaker", "")
	_type_full = line.get("text", "")
	_type_index = 0
	_is_typing = true
	speaker_label.text = spk
	speaker_label.visible = spk != ""
	voice_player.pitch_scale = GameState.SPEAKER_PITCH.get(spk, 1.0)
	dialogue_text.text = ""
	_update_face(spk, _type_full)
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
	if done or transitioning:
		return
	if not event.is_action_pressed("ui_accept"):
		return
	if _is_typing:
		dialogue_text.text = _type_full
		_is_typing = false
		type_timer.stop()
		return
	line_index += 1
	if line_index >= all_lines.size():
		done = true
		dialogue_box.visible = false
		_set_face("K", Color(0.25, 0.55, 0.95, 1), "K")
		final_title.visible = true
		$TotalLabel.visible = true
		$HighscoreLabel.visible = true
	else:
		if line_index == BOSS_LINES.size():
			await _play_k_transition()
		_start_typing(all_lines[line_index])

func _km_text(km: float) -> String:
	return "%0.2f km" % km

func _update_face(speaker: String, text: String):
	match speaker:
		"Mr. Gus":
			_set_face("Mr. Gus", Color(0.48, 0.16, 0.22, 1), "G")
		"K":
			_set_face("K", Color(0.25, 0.55, 0.95, 1), "K")
		"You":
			_set_face("You", Color(0.95, 0.72, 0.28, 1), "Y")
		_:
			if text.contains("K"):
				_set_face("K", Color(0.25, 0.55, 0.95, 1), "K")
			else:
				_hide_face()

func _set_face(face_key: String, fallback_color: Color, fallback_text: String):
	ending_face.color = fallback_color
	ending_face_label.text = fallback_text
	ending_face.visible = true
	ending_face_sprite.visible = true
	ending_face_sprite.set("texture_path", FACE_ART.get(face_key, ""))
	ending_face_sprite.call("refresh")

func _hide_face():
	ending_face.visible = false
	ending_face_sprite.visible = false

func _play_k_transition():
	transitioning = true
	var fade_out = create_tween()
	fade_out.tween_property(overlay, "color:a", 1.0, 0.35)
	await fade_out.finished
	var fade_in = create_tween()
	fade_in.tween_property(overlay, "color:a", 0.0, 0.45)
	await fade_in.finished
	transitioning = false
