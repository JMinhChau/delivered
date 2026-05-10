extends Node2D

const NPC_ITEM = {
	"Momo": "vegetables",
	"Pip": "sweets",
	"Benne": "flour",
	"Lou": "oranges"
}

const DIALOGUE = {
	"Momo": {
		1: {
			"delivered": [
				{"speaker": "Momo", "text": "Oh! You're not K."},
				{"speaker": "Momo", "text": "You have his ears, though. It's very strange."},
				{"speaker": "Momo", "text": "Tell him I'm making the mushroom soup. He knows the one."},
				{"speaker": "Momo", "text": "And eat something. You look like a strong wind would take you."},
			],
			"missed": [
				{"speaker": "Momo", "text": "No vegetables."},
				{"speaker": "Momo", "text": "I had a whole plan. The soup was going to be excellent."},
				{"speaker": "Momo", "text": "Tell K I saved the broth. He can have it when he's better."},
				{"speaker": "Momo", "text": "It's fine. I'm fine. Go."},
			]
		},
		2: {
			"streak": [
				{"speaker": "Momo", "text": "You're back."},
				{"speaker": "Momo", "text": "I wasn't sure you would be."},
				{"speaker": "Momo", "text": "The soup yesterday was very good, by the way."},
				{"speaker": "Momo", "text": "Tell K that. He'll be annoyed that he missed it."},
			],
			"recovery": [
				{"speaker": "Momo", "text": "Oh! Today you brought them."},
				{"speaker": "Momo", "text": "Yesterday I made a broth from whatever I had. It was sad."},
				{"speaker": "Momo", "text": "This is better. Much better."},
				{"speaker": "Momo", "text": "We don't need to talk about yesterday."},
			],
			"broke": [
				{"speaker": "Momo", "text": "Yesterday you had them. Today nothing."},
				{"speaker": "Momo", "text": "I see."},
				{"speaker": "Momo", "text": "The soup will be different now. Fewer mushrooms."},
				{"speaker": "Momo", "text": "It's fine. I'm adapting."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Two days."},
				{"speaker": "Momo", "text": "I've made a different soup."},
				{"speaker": "Momo", "text": "It's fine. It's a good soup."},
				{"speaker": "Momo", "text": "Tell K I said it's fine."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Momo", "text": "Three days."},
				{"speaker": "Momo", "text": "K never came three days in a row."},
				{"speaker": "Momo", "text": "I made extra. Don't tell anyone."},
				{"speaker": "Momo", "text": "Actually — tell whoever you want. I'm proud of the soup."},
			],
			"recovery": [
				{"speaker": "Momo", "text": "You came back after yesterday."},
				{"speaker": "Momo", "text": "I appreciate that."},
				{"speaker": "Momo", "text": "The soup is still good. I made it anyway, just in case."},
				{"speaker": "Momo", "text": "I always make it just in case."},
			],
			"broke": [
				{"speaker": "Momo", "text": "You had them two days and then—"},
				{"speaker": "Momo", "text": "Okay."},
				{"speaker": "Momo", "text": "I'm making a simpler soup today."},
				{"speaker": "Momo", "text": "It's fine. Simpler is sometimes better."},
				{"speaker": "Momo", "text": "It's not better. But it's fine."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Three days. No vegetables."},
				{"speaker": "Momo", "text": "I've moved on."},
				{"speaker": "Momo", "text": "There's a soup happening. It just doesn't have what it needs."},
				{"speaker": "Momo", "text": "Tell K to rest properly."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Momo", "text": "Four days."},
				{"speaker": "Momo", "text": "K never managed four days."},
				{"speaker": "Momo", "text": "I'm not going to tell him that."},
				{"speaker": "Momo", "text": "But I'm thinking it."},
			],
			"delivered": [
				{"speaker": "Momo", "text": "You came."},
				{"speaker": "Momo", "text": "K's back tomorrow, I heard."},
				{"speaker": "Momo", "text": "I'll have to make the regular soup again."},
				{"speaker": "Momo", "text": "It's a good soup. It's just... you've been getting the better one."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Last chance, I think."},
				{"speaker": "Momo", "text": "K comes back tomorrow."},
				{"speaker": "Momo", "text": "I was going to say something meaningful."},
				{"speaker": "Momo", "text": "No vegetables. I've forgotten what it was."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Momo", "text": "I figured you'd come."},
				{"speaker": "Momo", "text": "I made the soup thicker. In your honor."},
				{"speaker": "Momo", "text": "K came by this morning. He said you were..."},
				{"speaker": "Momo", "text": "He said 'adequate.' That's very high praise from K."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Last day. No soup for you."},
				{"speaker": "Momo", "text": "It's fine."},
				{"speaker": "Momo", "text": "You were good company. Mostly."},
				{"speaker": "Momo", "text": "Tell K I said... he's lucky."},
			]
		}
	},
	"Pip": {
		1: {
			"delivered": [
				{"speaker": "Pip", "text": "Oh perfect. Yes. Thank you."},
				{"speaker": "Pip", "text": "Wait — how old are you?"},
				{"speaker": "Pip", "text": "You know what, don't. I don't need to know."},
				{"speaker": "Pip", "text": "This conversation is not happening. We're good. Bye."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing? Same."},
				{"speaker": "Pip", "text": "I don't even remember what I ordered."},
				{"speaker": "Pip", "text": "Cool. This also didn't happen."},
				{"speaker": "Pip", "text": "I respect that about us."},
			]
		},
		2: {
			"streak": [
				{"speaker": "Pip", "text": "You again. Okay."},
				{"speaker": "Pip", "text": "Still not asking."},
				{"speaker": "Pip", "text": "We have a good system going. I like this."},
			],
			"recovery": [
				{"speaker": "Pip", "text": "Oh! Today you have it."},
				{"speaker": "Pip", "text": "Yesterday was a whole thing. We don't have to talk about it."},
				{"speaker": "Pip", "text": "Great. Perfect. You're doing great."},
			],
			"broke": [
				{"speaker": "Pip", "text": "Yesterday: yes. Today: no."},
				{"speaker": "Pip", "text": "Pattern noted."},
				{"speaker": "Pip", "text": "I respect the chaos. Honestly."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing again."},
				{"speaker": "Pip", "text": "Incredible. Consistent."},
				{"speaker": "Pip", "text": "You're like the weather. Unreliable but never boring."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Pip", "text": "Okay three days. Three days!"},
				{"speaker": "Pip", "text": "I'm going to say something and I need you to just accept it."},
				{"speaker": "Pip", "text": "You are kind of really good at this."},
				{"speaker": "Pip", "text": "Don't make it weird. I'm not making it weird. Bye."},
			],
			"recovery": [
				{"speaker": "Pip", "text": "You came back after yesterday."},
				{"speaker": "Pip", "text": "I respect the perseverance."},
				{"speaker": "Pip", "text": "Also this is exactly what I ordered and it's great. Okay."},
			],
			"broke": [
				{"speaker": "Pip", "text": "You had it twice and then—"},
				{"speaker": "Pip", "text": "No, I get it. Chaos. I contain multitudes. You contain multitudes."},
				{"speaker": "Pip", "text": "We're the same."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Three days. Nothing. Iconic."},
				{"speaker": "Pip", "text": "I've ordered something else. Don't worry about it."},
				{"speaker": "Pip", "text": "You're still doing a great job in general, I think."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Pip", "text": "FOUR DAYS."},
				{"speaker": "Pip", "text": "I have to tell you something."},
				{"speaker": "Pip", "text": "I've started planning my schedule around your arrival."},
				{"speaker": "Pip", "text": "That's either very good or slightly concerning. I choose good."},
			],
			"delivered": [
				{"speaker": "Pip", "text": "Oh! Last day probably, right?"},
				{"speaker": "Pip", "text": "K's back tomorrow."},
				{"speaker": "Pip", "text": "This is sad. I'm not going to say it's sad."},
				{"speaker": "Pip", "text": "It's a little sad."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing. It's fine."},
				{"speaker": "Pip", "text": "Last day and all that. Whatever."},
				{"speaker": "Pip", "text": "You were fine. You were great, actually."},
				{"speaker": "Pip", "text": "Don't tell K I said that."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Pip", "text": "Last one. Here we are."},
				{"speaker": "Pip", "text": "You've been the most competent mysterious delivery person I've ever had."},
				{"speaker": "Pip", "text": "I had three before you."},
				{"speaker": "Pip", "text": "All three were K. You were better."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Last day. Nothing. Full circle."},
				{"speaker": "Pip", "text": "Honestly? Poetic."},
				{"speaker": "Pip", "text": "It's been real. Whatever 'it' was."},
			]
		}
	},
	"Benne": {
		2: {
			"delivered": [
				{"speaker": "Benne", "text": "Finally."},
				{"speaker": "Benne", "text": "Do you know how long I've been waiting for this flour."},
				{"speaker": "Benne", "text": "You look twelve. No offense."},
				{"speaker": "Benne", "text": "It's an observation."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "..."},
				{"speaker": "Benne", "text": "The flour situation continues."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Benne", "text": "Second day."},
				{"speaker": "Benne", "text": "You're consistent. That's rare."},
				{"speaker": "Benne", "text": "K is not consistent."},
				{"speaker": "Benne", "text": "Don't tell him I said that. Actually, tell him."},
			],
			"recovery": [
				{"speaker": "Benne", "text": "Yesterday: nothing. Today: flour."},
				{"speaker": "Benne", "text": "I've made my peace with the pattern."},
				{"speaker": "Benne", "text": "Good flour though. Good weight."},
			],
			"broke": [
				{"speaker": "Benne", "text": "Yesterday you had it."},
				{"speaker": "Benne", "text": "Today: nothing."},
				{"speaker": "Benne", "text": "I baked without it. It was fine."},
				{"speaker": "Benne", "text": "It was not fine."},
			],
			"missed": [
				{"speaker": "Benne", "text": "Two days. No flour."},
				{"speaker": "Benne", "text": "I've developed a recipe that doesn't use flour."},
				{"speaker": "Benne", "text": "It's not bread. It's something else."},
				{"speaker": "Benne", "text": "I'm calling it 'the situation.'"},
			]
		},
		4: {
			"streak": [
				{"speaker": "Benne", "text": "Three days."},
				{"speaker": "Benne", "text": "K never came three days."},
				{"speaker": "Benne", "text": "I've made actual bread. Good bread."},
				{"speaker": "Benne", "text": "Here."},
				{"speaker": "Benne", "text": "Don't tell anyone. I have a reputation."},
			],
			"delivered": [
				{"speaker": "Benne", "text": "Last day, probably."},
				{"speaker": "Benne", "text": "Take the bread."},
				{"speaker": "Benne", "text": "Yes I made extra. I'm not explaining myself."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "Last day."},
				{"speaker": "Benne", "text": "Tell K: adequate."},
				{"speaker": "Benne", "text": "He'll know what it means."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Benne", "text": "Last one."},
				{"speaker": "Benne", "text": "I made a loaf. It's in the bag."},
				{"speaker": "Benne", "text": "For K."},
				{"speaker": "Benne", "text": "..."},
				{"speaker": "Benne", "text": "And for you."},
				{"speaker": "Benne", "text": "Don't make it a whole thing."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour. Last day."},
				{"speaker": "Benne", "text": "It's fine."},
				{"speaker": "Benne", "text": "You tried. Mostly."},
			]
		}
	},
	"Lou": {
		4: {
			"streak": [
				{"speaker": "Lou", "text": "K mentioned you'd be on time."},
				{"speaker": "Lou", "text": "He was right."},
				{"speaker": "Lou", "text": "Surprising."},
				{"speaker": "Lou", "text": "Here. Oranges. Don't ask."},
			],
			"delivered": [
				{"speaker": "Lou", "text": "K said 'probably.'"},
				{"speaker": "Lou", "text": "About you. 'Probably reliable.'"},
				{"speaker": "Lou", "text": "He was right."},
				{"speaker": "Lou", "text": "Probably."},
			],
			"missed": [
				{"speaker": "Lou", "text": "K said you'd be here."},
				{"speaker": "Lou", "text": "He's wrong sometimes."},
				{"speaker": "Lou", "text": "The oranges will keep."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Lou", "text": "Last day."},
				{"speaker": "Lou", "text": "You did good."},
				{"speaker": "Lou", "text": "K knows."},
				{"speaker": "Lou", "text": "He won't say it, but he knows."},
			],
			"missed": [
				{"speaker": "Lou", "text": "Last day."},
				{"speaker": "Lou", "text": "You tried."},
				{"speaker": "Lou", "text": "That counts for something."},
				{"speaker": "Lou", "text": "Take an orange."},
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
