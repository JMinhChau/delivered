extends Node2D

const NPC_ITEM = {
	"Momo": "vegetables",
	"Pip": "sweets",
	"Benne": "flour",
	"Lou": "oranges"
}

const NPC_FACE_COLOR = {
	"Momo": Color(0.95, 0.6, 0.25, 1),
	"Pip": Color(0.3, 0.75, 0.72, 1),
	"Benne": Color(0.55, 0.38, 0.22, 1),
	"Lou": Color(0.58, 0.4, 0.78, 1),
}

const NPC_FACE_ART = {
	"Momo": "res://art/town/momo_face.png",
	"Pip": "res://art/town/pip_face.png",
	"Benne": "res://art/town/benne_face.png",
	"Lou": "res://art/town/lou_face.png",
}

const DIALOGUE = {
	"Momo": {
		1: {
			"delivered": [
				{"speaker": "Momo", "text": "You're not K."},
				{"speaker": "Momo", "text": "You have his ears, though."},
				{"speaker": "Momo", "text": "Tell him the mushroom soup turned out well."},
			],
			"missed": [
				{"speaker": "Momo", "text": "No vegetables."},
				{"speaker": "Momo", "text": "I had a whole plan for soup."},
				{"speaker": "Momo", "text": "Tell K his family is bad at this."},
			]
		},
		2: {
			"streak": [
				{"speaker": "Momo", "text": "You're back."},
				{"speaker": "Momo", "text": "The soup was excellent, by the way."},
				{"speaker": "Momo", "text": "Two days in a row. K never managed two."},
			],
			"recovery": [
				{"speaker": "Momo", "text": "Yesterday nothing. Today yes."},
				{"speaker": "Momo", "text": "I made the broth anyway. Just in case."},
				{"speaker": "Momo", "text": "It paid off."},
			],
			"broke": [
				{"speaker": "Momo", "text": "Yesterday yes. Today no."},
				{"speaker": "Momo", "text": "Fewer mushrooms."},
				{"speaker": "Momo", "text": "More... broth."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Two days. No vegetables."},
				{"speaker": "Momo", "text": "I adapted."},
				{"speaker": "Momo", "text": "The soup is not as good."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Momo", "text": "Three days in a row."},
				{"speaker": "Momo", "text": "K has never done three."},
				{"speaker": "Momo", "text": "I made extra. Don't tell him."},
			],
			"recovery": [
				{"speaker": "Momo", "text": "You came back."},
				{"speaker": "Momo", "text": "The soup was waiting."},
				{"speaker": "Momo", "text": "I always make it just in case."},
			],
			"broke": [
				{"speaker": "Momo", "text": "Two days yes. Today no."},
				{"speaker": "Momo", "text": "Simpler soup."},
				{"speaker": "Momo", "text": "Not better. Fine."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Three days. No vegetables."},
				{"speaker": "Momo", "text": "I've moved on."},
				{"speaker": "Momo", "text": "Tell K to rest."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Momo", "text": "Four days."},
				{"speaker": "Momo", "text": "K never made it past two."},
				{"speaker": "Momo", "text": "I'm not saying you're better."},
				{"speaker": "Momo", "text": "But."},
			],
			"delivered": [
				{"speaker": "Momo", "text": "K's back tomorrow."},
				{"speaker": "Momo", "text": "You came anyway."},
				{"speaker": "Momo", "text": "He's going to hear about this soup."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Last chance, probably."},
				{"speaker": "Momo", "text": "K's back tomorrow."},
				{"speaker": "Momo", "text": "I'll save my thoughts."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Momo", "text": "Last day."},
				{"speaker": "Momo", "text": "I made it thicker. For you."},
				{"speaker": "Momo", "text": "K said you were 'probably fine.'"},
				{"speaker": "Momo", "text": "Coming from him, that's a lot."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Last day. No soup ingredients."},
				{"speaker": "Momo", "text": "Tell K his sibling tried."},
				{"speaker": "Momo", "text": "...mostly."},
			]
		}
	},
	"Pip": {
		1: {
			"delivered": [
				{"speaker": "Pip", "text": "OH. You're K's sibling."},
				{"speaker": "Pip", "text": "He said you were 'basically him.'"},
				{"speaker": "Pip", "text": "You're not basically him."},
				{"speaker": "Pip", "text": "Anyway. Bye."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing?"},
				{"speaker": "Pip", "text": "Same. I forgot what I ordered anyway."},
				{"speaker": "Pip", "text": "This didn't happen."},
			]
		},
		2: {
			"streak": [
				{"speaker": "Pip", "text": "You again."},
				{"speaker": "Pip", "text": "Does K know you're actually good at this?"},
				{"speaker": "Pip", "text": "Don't tell him. Let him feel needed."},
			],
			"recovery": [
				{"speaker": "Pip", "text": "You showed up today."},
				{"speaker": "Pip", "text": "Yesterday was a miss. But today counts."},
				{"speaker": "Pip", "text": "Great system. Bye."},
			],
			"broke": [
				{"speaker": "Pip", "text": "Yesterday yes, today no."},
				{"speaker": "Pip", "text": "Chaotic neutral."},
				{"speaker": "Pip", "text": "Just like K, honestly."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing again."},
				{"speaker": "Pip", "text": "Consistently inconsistent."},
				{"speaker": "Pip", "text": "Just like the weather. Just like K."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Pip", "text": "Three days!"},
				{"speaker": "Pip", "text": "You're genuinely good at this."},
				{"speaker": "Pip", "text": "Don't make it weird."},
				{"speaker": "Pip", "text": "Bye."},
			],
			"recovery": [
				{"speaker": "Pip", "text": "You came back."},
				{"speaker": "Pip", "text": "Respect the hustle."},
				{"speaker": "Pip", "text": "Don't stop. Bye."},
			],
			"broke": [
				{"speaker": "Pip", "text": "Twice yes, then no."},
				{"speaker": "Pip", "text": "We contain multitudes."},
				{"speaker": "Pip", "text": "K would've done the same."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Three days. Nothing."},
				{"speaker": "Pip", "text": "Iconic, honestly."},
				{"speaker": "Pip", "text": "I ordered something else. Don't worry about it."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Pip", "text": "FOUR DAYS."},
				{"speaker": "Pip", "text": "I schedule around you now."},
				{"speaker": "Pip", "text": "This is getting out of hand."},
				{"speaker": "Pip", "text": "I'm fine with it."},
			],
			"delivered": [
				{"speaker": "Pip", "text": "K's back tomorrow?"},
				{"speaker": "Pip", "text": "Hm. A little sad. Just a little."},
				{"speaker": "Pip", "text": "Don't tell K."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing. Fine."},
				{"speaker": "Pip", "text": "You were actually great."},
				{"speaker": "Pip", "text": "Don't tell K I said that."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Pip", "text": "Last one. Here we are."},
				{"speaker": "Pip", "text": "You're better than K."},
				{"speaker": "Pip", "text": "I'm going to tell him that."},
				{"speaker": "Pip", "text": "To his face."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Last day. Nothing."},
				{"speaker": "Pip", "text": "Poetic, honestly."},
				{"speaker": "Pip", "text": "It's been real. Tell K hi."},
			]
		}
	},
	"Benne": {
		2: {
			"delivered": [
				{"speaker": "Benne", "text": "Finally."},
				{"speaker": "Benne", "text": "The flour."},
				{"speaker": "Benne", "text": "You look like K. Shorter."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "I've been waiting three days."},
				{"speaker": "Benne", "text": "The buns are suffering."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Benne", "text": "Two days in a row."},
				{"speaker": "Benne", "text": "You're reliable."},
				{"speaker": "Benne", "text": "Tell K. Maybe he'll learn something."},
			],
			"recovery": [
				{"speaker": "Benne", "text": "Yesterday nothing. Today yes."},
				{"speaker": "Benne", "text": "Good weight on that bag."},
				{"speaker": "Benne", "text": "The buns are less sad."},
			],
			"broke": [
				{"speaker": "Benne", "text": "Yesterday yes. Today no."},
				{"speaker": "Benne", "text": "I baked without it."},
				{"speaker": "Benne", "text": "It wasn't bread. Don't ask what it was."},
			],
			"missed": [
				{"speaker": "Benne", "text": "Two days. No flour."},
				{"speaker": "Benne", "text": "I made a flourless recipe."},
				{"speaker": "Benne", "text": "It's not bread. I don't want to talk about it."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Benne", "text": "Three days."},
				{"speaker": "Benne", "text": "I made actual bread."},
				{"speaker": "Benne", "text": "Take a loaf."},
				{"speaker": "Benne", "text": "I'm not explaining myself."},
			],
			"delivered": [
				{"speaker": "Benne", "text": "Last day, probably."},
				{"speaker": "Benne", "text": "Take the bread."},
				{"speaker": "Benne", "text": "Tell K his sibling earned it."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "Tell K: adequate."},
				{"speaker": "Benne", "text": "That's all."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Benne", "text": "Last one."},
				{"speaker": "Benne", "text": "There's a loaf in the bag."},
				{"speaker": "Benne", "text": "For you."},
				{"speaker": "Benne", "text": "K gets nothing."},
			],
			"missed": [
				{"speaker": "Benne", "text": "Last day. No flour."},
				{"speaker": "Benne", "text": "You tried."},
				{"speaker": "Benne", "text": "...mostly."},
			]
		}
	},
	"Lou": {
		4: {
			"streak": [
				{"speaker": "Lou", "text": "K said you'd probably show up."},
				{"speaker": "Lou", "text": "'Probably' is high praise from him."},
				{"speaker": "Lou", "text": "Take an orange."},
				{"speaker": "Lou", "text": "Don't make a thing of it."},
			],
			"delivered": [
				{"speaker": "Lou", "text": "K said you were 'probably reliable.'"},
				{"speaker": "Lou", "text": "He was right. Probably."},
			],
			"missed": [
				{"speaker": "Lou", "text": "K said you'd be here."},
				{"speaker": "Lou", "text": "He's wrong sometimes."},
				{"speaker": "Lou", "text": "Tell him it happens."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Lou", "text": "Last day. You showed up."},
				{"speaker": "Lou", "text": "K knows."},
				{"speaker": "Lou", "text": "He won't say it."},
				{"speaker": "Lou", "text": "But he knows."},
			],
			"missed": [
				{"speaker": "Lou", "text": "Last day."},
				{"speaker": "Lou", "text": "K tried his first week too."},
				{"speaker": "Lou", "text": "You're ahead of where he started."},
			]
		}
	}
}

var visited = []
var current_npc = ""
var current_lines = []
var current_line_idx = 0
var pending_item_key = ""
var _type_full = ""
var _type_index = 0
var _is_typing = false
var temp_delivery_log = {}
var selected_index = 0

@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var speaker_label = $DialogueBox/SpeakerLabel
@onready var leave_button = $LeaveButton
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer
@onready var dialogue_face = $DialogueFace
@onready var dialogue_face_label = $DialogueFace/FaceLabel
@onready var dialogue_face_sprite = $DialogueFaceSprite

func _ready():
	type_timer.timeout.connect(_on_type_tick)
	
	var bg = get_node_or_null("Background")
	if bg:
		match GameState.day:
			1: bg.color = Color(0.4, 0.7, 0.9)   # Morning blue
			2: bg.color = Color(0.35, 0.65, 0.85) # Midday
			3: bg.color = Color(0.5, 0.55, 0.8)   # Afternoon
			4: bg.color = Color(0.75, 0.55, 0.4)  # Sunset edge
			5: bg.color = Color(0.85, 0.65, 0.3)  # Golden sunset

	for npc_name in ["Momo", "Pip", "Benne", "Lou"]:
		var npc = get_node_or_null(npc_name)
		if npc:
			if npc_name in GameState.active_npcs:
				npc.input_event.connect(_on_npc_clicked.bind(npc_name))
				npc.visible = true
			else:
				npc.visible = false
	leave_button.pressed.connect(_on_leave)
	dialogue_face.visible = false
	dialogue_face_sprite.visible = false

func _pick_variant(npc_name: String, has_item: bool) -> String:
	var log = GameState.npc_delivery_log.get(npc_name, [])
	var got_yesterday = log.size() >= 1 and log[-1]
	var streak_count = 0
	for i in range(log.size() - 1, -1, -1):
		if log[i]: streak_count += 1
		else: break
	
	if has_item:
		if streak_count >= 1: return "streak"
		if not got_yesterday and log.size() >= 1: return "recovery"
		return "delivered"
	else:
		if got_yesterday: return "broke"
		return "missed"

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

func _process(delta):
	if GameState.active_npcs.is_empty(): return
	var active = GameState.active_npcs
	
	if not dialogue_box.visible and current_npc == "" and visited.size() < active.size():
		if Input.is_action_just_pressed("ui_right"):
			selected_index = (selected_index + 1) % active.size()
			while active[selected_index] in visited:
				selected_index = (selected_index + 1) % active.size()
		elif Input.is_action_just_pressed("ui_left"):
			selected_index = (selected_index - 1 + active.size()) % active.size()
			while active[selected_index] in visited:
				selected_index = (selected_index - 1 + active.size()) % active.size()
				
	for i in range(active.size()):
		var npc_name = active[i]
		var npc = get_node_or_null(npc_name)
		if not npc: continue
		if npc_name in visited:
			npc.scale = npc.scale.move_toward(Vector2(0.9, 0.9), delta * 5.0)
			npc.modulate.a = 0.5
		elif i == selected_index and not dialogue_box.visible and current_npc == "":
			npc.scale = npc.scale.move_toward(Vector2(1.2, 1.2), delta * 8.0)
			npc.modulate.a = 1.0
		else:
			npc.scale = npc.scale.move_toward(Vector2(1.0, 1.0), delta * 5.0)
			npc.modulate.a = 1.0

func _start_interaction(npc_name):
	if npc_name in visited or current_npc != "":
		return

	current_npc = npc_name
	_show_dialogue_face(npc_name)
	var item_key = NPC_ITEM[npc_name]
	var has_item = GameState.inventory.get(item_key, 0) > 0
	
	var variant_key = _pick_variant(npc_name, has_item)
	var day_dialogue = DIALOGUE.get(npc_name, {}).get(GameState.day, {})
	
	# Fallbacks
	if not day_dialogue.has(variant_key):
		variant_key = "delivered" if has_item else "missed"
	
	current_lines = day_dialogue.get(variant_key, [{"speaker": npc_name, "text": "..."}])
	
	pending_item_key = item_key if has_item else ""
	temp_delivery_log[npc_name] = has_item # Track for salary scene to commit
	
	# Visual feedback pulse
	var npc_node = get_node_or_null(npc_name)
	if npc_node:
		var target_color = Color(1.0, 0.9, 0.4) if has_item else Color(0.4, 0.4, 0.4)
		var tw = create_tween()
		tw.tween_property(npc_node, "modulate", target_color, 0.1)
		tw.tween_property(npc_node, "modulate", Color.WHITE, 0.3)
	
	current_line_idx = 0
	dialogue_box.visible = true
	_start_typing(current_lines[0])

func _on_npc_clicked(viewport, event, shape, npc_name):
	if not event is InputEventMouseButton or not event.pressed:
		return
	_start_interaction(npc_name)

func _unhandled_input(event):
	if dialogue_box.visible:
		if not event.is_action_pressed("ui_accept"):
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
			dialogue_face.visible = false
			dialogue_face_sprite.visible = false
			
			if visited.size() < GameState.active_npcs.size():
				# Select next unvisited
				for i in range(GameState.active_npcs.size()):
					if not GameState.active_npcs[i] in visited:
						selected_index = i
						break
			else:
				leave_button.visible = true
				leave_button.grab_focus()
	else:
		if event.is_action_pressed("ui_accept"):
			if visited.size() == GameState.active_npcs.size():
				_on_leave()
			elif current_npc == "":
				var npc_name = GameState.active_npcs[selected_index]
				_start_interaction(npc_name)

func _on_leave():
	# Pass temporary delivery status to next scene via GameState
	for npc in temp_delivery_log:
		if not GameState.npc_delivery_log.has(npc):
			GameState.npc_delivery_log[npc] = []
		GameState.npc_delivery_log[npc].append(temp_delivery_log[npc])
		if temp_delivery_log[npc]:
			GameState.total_deliveries += 1
	GameState.day_history.append(GameState.items_delivered)
	get_tree().change_scene_to_file("res://salary_scene.tscn")

func _show_dialogue_face(npc_name: String):
	dialogue_face.color = NPC_FACE_COLOR.get(npc_name, Color(1, 1, 1, 1))
	dialogue_face_label.text = npc_name.substr(0, 1)
	dialogue_face.visible = true
	dialogue_face_sprite.visible = true
	dialogue_face_sprite.set("texture_path", NPC_FACE_ART.get(npc_name, ""))
	dialogue_face_sprite.call("refresh")
