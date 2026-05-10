extends Node2D

const BOSS_LINES = [
	{"speaker": "Mr. Gus", "text": "K's back tomorrow."},
	{"speaker": "Mr. Gus", "text": "Tell him—"},
	{"speaker": "Mr. Gus", "text": "—adequate work."},
	{"speaker": "Mr. Gus", "text": "The envelope is short."},
	{"speaker": "Mr. Gus", "text": "Training fee."},
	{"speaker": "Mr. Gus", "text": "..."},
	{"speaker": "Mr. Gus", "text": "Don't come back."},
	{"speaker": "Mr. Gus", "text": "Unless K calls in sick again."},
]

const ENDING_GOOD = [
	{"speaker": "",    "text": "K is waiting outside."},
	{"speaker": "K",   "text": "You're back."},
	{"speaker": "You", "text": "..."},
	{"speaker": "K",   "text": "Gus called me. He said I'm getting a raise."},
	{"speaker": "K",   "text": "What did you do?"},
	{"speaker": "You", "text": "Nothing. Just drove."},
	{"speaker": "K",   "text": "He said you were 'adequate'. From Gus, that's practically a marriage proposal."},
	{"speaker": "",    "text": "You walk home. It's a warm evening."},
	{"speaker": "",    "text": "You never mention the wrong way."}
]

const ENDING_NEUTRAL = [
	{"speaker": "",    "text": "K is waiting outside."},
	{"speaker": "K",   "text": "You're back."},
	{"speaker": "You", "text": "..."},
	{"speaker": "K",   "text": "Gus called. Said I still have a job."},
	{"speaker": "K",   "text": "Barely."},
	{"speaker": "You", "text": "I tried."},
	{"speaker": "K",   "text": "I know. Thanks."},
	{"speaker": "",    "text": "You walk home. It's a warm evening."},
	{"speaker": "",    "text": "You never mention the wrong way."}
]

const ENDING_BAD = [
	{"speaker": "",    "text": "K is waiting outside."},
	{"speaker": "K",   "text": "You're back."},
	{"speaker": "You", "text": "..."},
	{"speaker": "K",   "text": "Gus called. I'm fired."},
	{"speaker": "You", "text": "I'm sorry."},
	{"speaker": "K",   "text": "It's fine. I hated that job anyway."},
	{"speaker": "K",   "text": "Did you at least have fun?"},
	{"speaker": "You", "text": "No."},
	{"speaker": "",    "text": "You walk home. It's a warm evening."},
	{"speaker": "",    "text": "You never mention the wrong way."}
]

var all_lines = []
var line_index = 0
var done = false
var _type_full = ""
var _type_index = 0
var _is_typing = false

@onready var dialogue_text = $DialogueBox/DialogueText
@onready var speaker_label = $DialogueBox/SpeakerLabel
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer

func _ready():
	$TotalLabel.text = "Total: $" + str(GameState.money)
	if GameState.total_km > 0 or GameState.best_km > 0:
		$HighscoreLabel.text = "Km: " + _km_text(GameState.total_km) + " / best " + _km_text(GameState.best_km)
		$HighscoreLabel.visible = true
	
	var ending_lines = ENDING_NEUTRAL
	if GameState.total_deliveries >= 12:
		ending_lines = ENDING_GOOD
	elif GameState.total_deliveries < 7:
		ending_lines = ENDING_BAD
		
	all_lines = BOSS_LINES + ending_lines
	type_timer.timeout.connect(_on_type_tick)
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
	if done:
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
		dialogue_text.text = ""
		speaker_label.visible = false
		$TotalLabel.visible = true
	else:
		_start_typing(all_lines[line_index])

func _km_text(km: float) -> String:
	return "%0.2f km" % km
