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
				{"speaker": "Momo", "text": "Oh. You're not K."},
				{"speaker": "Momo", "text": "Same ears, though. Weird."},
				{"speaker": "Momo", "text": "Tell him I'm making the mushroom soup."},
			],
			"missed": [
				{"speaker": "Momo", "text": "No vegetables."},
				{"speaker": "Momo", "text": "I had a whole plan for soup."},
				{"speaker": "Momo", "text": "Tell K I saved the broth anyway."},
			]
		},
		2: {
			"streak": [
				{"speaker": "Momo", "text": "You're back."},
				{"speaker": "Momo", "text": "The soup was good, by the way."},
				{"speaker": "Momo", "text": "Tell K he missed out."},
			],
			"recovery": [
				{"speaker": "Momo", "text": "Oh, today you have them."},
				{"speaker": "Momo", "text": "Yesterday's broth was sad."},
				{"speaker": "Momo", "text": "This is better."},
			],
			"broke": [
				{"speaker": "Momo", "text": "Yesterday yes, today no."},
				{"speaker": "Momo", "text": "Fewer mushrooms, then."},
				{"speaker": "Momo", "text": "I'll adapt."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Two days."},
				{"speaker": "Momo", "text": "Made a different soup."},
				{"speaker": "Momo", "text": "It's fine."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Momo", "text": "Three days. Wow."},
				{"speaker": "Momo", "text": "K never managed three days."},
				{"speaker": "Momo", "text": "Made extra. Don't tell."},
			],
			"recovery": [
				{"speaker": "Momo", "text": "You came back."},
				{"speaker": "Momo", "text": "Soup's still good."},
				{"speaker": "Momo", "text": "Always make it just in case."},
			],
			"broke": [
				{"speaker": "Momo", "text": "Two days of yes, now no."},
				{"speaker": "Momo", "text": "Simpler soup today."},
				{"speaker": "Momo", "text": "Not better. But fine."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Three days. No veg."},
				{"speaker": "Momo", "text": "I've moved on."},
				{"speaker": "Momo", "text": "Tell K to rest."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Momo", "text": "Four days."},
				{"speaker": "Momo", "text": "K never managed four."},
				{"speaker": "Momo", "text": "I won't tell him."},
				{"speaker": "Momo", "text": "But I'll think it."},
			],
			"delivered": [
				{"speaker": "Momo", "text": "You came."},
				{"speaker": "Momo", "text": "K's back tomorrow."},
				{"speaker": "Momo", "text": "Back to regular soup soon."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Last chance, probably."},
				{"speaker": "Momo", "text": "K's back tomorrow."},
				{"speaker": "Momo", "text": "I'll save my meaningful words."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Momo", "text": "Made it thicker. For you."},
				{"speaker": "Momo", "text": "K said you were 'adequate'."},
				{"speaker": "Momo", "text": "High praise from him."},
			],
			"missed": [
				{"speaker": "Momo", "text": "Last day. No soup."},
				{"speaker": "Momo", "text": "It's fine. You were okay."},
				{"speaker": "Momo", "text": "Tell K he's lucky."},
			]
		}
	},
	"Pip": {
		1: {
			"delivered": [
				{"speaker": "Pip", "text": "Oh perfect. Yes."},
				{"speaker": "Pip", "text": "Wait. How old are you?"},
				{"speaker": "Pip", "text": "Don't answer. We're good. Bye."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing? Same."},
				{"speaker": "Pip", "text": "Forgot what I ordered anyway."},
				{"speaker": "Pip", "text": "This didn't happen."},
			]
		},
		2: {
			"streak": [
				{"speaker": "Pip", "text": "You again."},
				{"speaker": "Pip", "text": "Still not asking."},
				{"speaker": "Pip", "text": "Good system we have."},
			],
			"recovery": [
				{"speaker": "Pip", "text": "Oh, today you have it."},
				{"speaker": "Pip", "text": "Yesterday was... whatever."},
				{"speaker": "Pip", "text": "Perfect. Great."},
			],
			"broke": [
				{"speaker": "Pip", "text": "Yesterday yes, today no."},
				{"speaker": "Pip", "text": "Pattern noted."},
				{"speaker": "Pip", "text": "I respect the chaos."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing again."},
				{"speaker": "Pip", "text": "Consistently inconsistent."},
				{"speaker": "Pip", "text": "Like the weather."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Pip", "text": "Three days!"},
				{"speaker": "Pip", "text": "You're actually good at this."},
				{"speaker": "Pip", "text": "Don't make it weird. Bye."},
			],
			"recovery": [
				{"speaker": "Pip", "text": "You came back."},
				{"speaker": "Pip", "text": "Respect the hustle."},
				{"speaker": "Pip", "text": "This is great. Bye."},
			],
			"broke": [
				{"speaker": "Pip", "text": "Twice yes, then no."},
				{"speaker": "Pip", "text": "I contain multitudes too."},
				{"speaker": "Pip", "text": "We're the same."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Three days. Iconic."},
				{"speaker": "Pip", "text": "Ordered something else."},
				{"speaker": "Pip", "text": "Don't worry about it."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Pip", "text": "FOUR DAYS."},
				{"speaker": "Pip", "text": "I plan my schedule around you now."},
				{"speaker": "Pip", "text": "Slightly concerning. But okay."},
			],
			"delivered": [
				{"speaker": "Pip", "text": "Last day probably?"},
				{"speaker": "Pip", "text": "K's back tomorrow."},
				{"speaker": "Pip", "text": "A little sad. Just a little."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Nothing. Fine."},
				{"speaker": "Pip", "text": "You were great, actually."},
				{"speaker": "Pip", "text": "Don't tell K."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Pip", "text": "Last one. Here we are."},
				{"speaker": "Pip", "text": "Most competent delivery kid ever."},
				{"speaker": "Pip", "text": "Way better than K."},
			],
			"missed": [
				{"speaker": "Pip", "text": "Last day. Nothing."},
				{"speaker": "Pip", "text": "Poetic, honestly."},
				{"speaker": "Pip", "text": "It's been real."},
			]
		}
	},
	"Benne": {
		2: {
			"delivered": [
				{"speaker": "Benne", "text": "Finally."},
				{"speaker": "Benne", "text": "Been waiting on this flour."},
				{"speaker": "Benne", "text": "You look twelve."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "The situation continues."},
			]
		},
		3: {
			"streak": [
				{"speaker": "Benne", "text": "Second day."},
				{"speaker": "Benne", "text": "You're consistent."},
				{"speaker": "Benne", "text": "Tell K I said that."},
			],
			"recovery": [
				{"speaker": "Benne", "text": "Yesterday nothing. Today flour."},
				{"speaker": "Benne", "text": "Good weight, though."},
			],
			"broke": [
				{"speaker": "Benne", "text": "Yesterday yes, today no."},
				{"speaker": "Benne", "text": "Baked without it. Wasn't fine."},
			],
			"missed": [
				{"speaker": "Benne", "text": "Two days."},
				{"speaker": "Benne", "text": "Making a flourless recipe."},
				{"speaker": "Benne", "text": "It's not bread."},
			]
		},
		4: {
			"streak": [
				{"speaker": "Benne", "text": "Three days."},
				{"speaker": "Benne", "text": "Made actual bread."},
				{"speaker": "Benne", "text": "Here. Don't tell anyone."},
			],
			"delivered": [
				{"speaker": "Benne", "text": "Last day, maybe."},
				{"speaker": "Benne", "text": "Take the bread."},
				{"speaker": "Benne", "text": "I'm not explaining myself."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour."},
				{"speaker": "Benne", "text": "Tell K: adequate."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Benne", "text": "Last one."},
				{"speaker": "Benne", "text": "Made a loaf. In the bag."},
				{"speaker": "Benne", "text": "For you."},
				{"speaker": "Benne", "text": "Don't make it a thing."},
			],
			"missed": [
				{"speaker": "Benne", "text": "No flour. Last day."},
				{"speaker": "Benne", "text": "You tried. Mostly."},
			]
		}
	},
	"Lou": {
		4: {
			"streak": [
				{"speaker": "Lou", "text": "K said you'd be on time."},
				{"speaker": "Lou", "text": "Surprising."},
				{"speaker": "Lou", "text": "Take an orange. Don't ask."},
			],
			"delivered": [
				{"speaker": "Lou", "text": "K said 'probably reliable'."},
				{"speaker": "Lou", "text": "He was right. Probably."},
			],
			"missed": [
				{"speaker": "Lou", "text": "K said you'd be here."},
				{"speaker": "Lou", "text": "He's wrong sometimes."},
			]
		},
		5: {
			"delivered": [
				{"speaker": "Lou", "text": "Last day. You did good."},
				{"speaker": "Lou", "text": "K knows. Won't say it, but knows."},
			],
			"missed": [
				{"speaker": "Lou", "text": "Last day. You tried."},
				{"speaker": "Lou", "text": "That counts for something."},
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
