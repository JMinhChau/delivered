extends Node2D

@export var obstacle_scene: PackedScene
@export var gas_pickup_scene: PackedScene
@export var road_hazard_scene: PackedScene
@export var ambulance_scene: PackedScene
@export var drunkard_scene: PackedScene

const LANES = [60, 90, 120]
const TIMER_BAR_MAX_WIDTH = 60.0
const ROAD_FALLBACK_TILE_WIDTH = 160.0

# 5-day constants
const TIME_BASE_BY_DAY     = {1: 24.0, 2: 18.0, 3: 14.0, 4: 12.0, 5: 10.0}
const TIME_MAX_BY_DAY      = {1: 28.0, 2: 22.0, 3: 18.0, 4: 16.0, 5: 14.0}
const CAR_SPAWN_WAIT_BY_DAY = {1: 2.6, 2: 2.35, 3: 2.15, 4: 1.9, 5: 1.7}
const GAS_INTERVAL_BY_DAY  = {1: 6.0,  2: 5.0,  3: 4.0,  4: 3.5, 5: 3.0}
const SWERVE_CHANCE        = {1: 0.0,  2: 0.20, 3: 0.35, 4: 0.50, 5: 0.65}
const ROAD_SPEED_START_BY_DAY = {1: 58.0, 2: 66.0, 3: 74.0, 4: 82.0, 5: 90.0}
const ROAD_SPEED_END_BY_DAY   = {1: 88.0, 2: 122.0, 3: 150.0, 4: 175.0, 5: 200.0}
const ROAD_SPEED_RAMP_BY_DAY  = {1: 28.0, 2: 22.0, 3: 18.0, 4: 15.0, 5: 12.0}
const HAZARD_COOLDOWN_BY_DAY = {2: Vector2(3.5, 5.0), 3: Vector2(2.7, 4.2), 4: Vector2(2.2, 3.5), 5: Vector2(1.8, 2.8)}

const IGNITION_THRESHOLD_BY_DAY = {1: 0.70, 2: 0.62, 3: 0.55, 4: 0.50, 5: 0.45}
const IGNITION_TAP_GAIN_BY_DAY = {1: 0.18, 2: 0.22, 3: 0.26, 4: 0.30, 5: 0.35}
const IGNITION_DECAY_BY_DAY = {1: 0.55, 2: 0.42, 3: 0.32, 4: 0.25, 5: 0.20}
const IGNITION_HOLD_TIME_BY_DAY = {1: 0.75, 2: 0.60, 3: 0.45, 4: 0.35, 5: 0.25}

const KM_PER_SPEED_SECOND = 0.0009
const GAS_KM_BONUS = 0.08
const NEAR_MISS_TIME_BONUS = 0.35
const IGNITION_BONUS_MIN = 1
const IGNITION_BONUS_MAX = 4
const IGNITION_BAR_MAX = 80.0

const DAY_PALETTE = {
	1: { "sky": Color(0.45, 0.75, 0.95), "grass": Color(0.35, 0.72, 0.38), "prop": Color(0.95, 0.80, 0.35) },
	2: { "sky": Color(0.42, 0.68, 0.90), "grass": Color(0.38, 0.68, 0.35), "prop": Color(0.78, 0.60, 0.28) },
	3: { "sky": Color(0.55, 0.62, 0.85), "grass": Color(0.32, 0.60, 0.30), "prop": Color(0.68, 0.45, 0.22) },
	4: { "sky": Color(0.80, 0.60, 0.42), "grass": Color(0.30, 0.55, 0.28), "prop": Color(0.55, 0.35, 0.18) },
	5: { "sky": Color(0.92, 0.76, 0.48), "grass": Color(0.28, 0.50, 0.26), "prop": Color(0.85, 0.70, 0.40) }
}

var time_remaining: float
var run_time_max: float
var road_speed = 0.0
var speed_progress = 0.0
var drive_elapsed = 0.0
var hazard_cooldown = 999.0
var best_km_at_run_start = 0.0
var best_flash_done = false
var igniting = false
var ignition_ready = false
var ending = false
var hold_power = 0.0
var ignition_hold_time = 0.0
var ambulance_spawned = false
var drunkard_spawned = false

var road_tiles = []
var road_fallback_tiles = []
var road_dashes = []
var parallax_layers = []
var road_tile_width = ROAD_FALLBACK_TILE_WIDTH
var road_layer: Node2D
var speed_lines_layer: Node2D
var tap_player: AudioStreamPlayer
var hold_player: AudioStreamPlayer
var start_player: AudioStreamPlayer

@onready var truck = $Truck
@onready var wrong_way_label = $HUD/Panel/WrongWayLabel
@onready var timer_bar = $HUD/Panel/TimerBar
@onready var parcel_icons = [
	$HUD/Panel/Parcel1,
	$HUD/Panel/Parcel2,
	$HUD/Panel/Parcel3,
	$HUD/Panel/Parcel4,
	$HUD/Panel/Parcel5,
]
@onready var chain_label = $HUD/Panel/ChainLabel
@onready var town_board = $HUD/TownBoard
@onready var ignition_hint = $HUD/IgnitionHint
@onready var ignition_bar_bg = $HUD/IgnitionBarBg
@onready var ignition_zone = $HUD/IgnitionZone
@onready var ignition_fill = $HUD/IgnitionFill
@onready var ignition_dim = $HUD/IgnitionDim
@onready var score_hud_label = $HUD/ScoreHudLabel
@onready var thought_label = $HUD/ThoughtLabel
@onready var hud_layer = $HUD

func _ready():
	_build_road_layers()
	_build_audio()

	GameState.near_miss_chain = 0
	GameState.gas_collected = 0
	GameState.drive_km = 0.0
	GameState.drive_score = 0
	GameState.last_ignition_bonus = 0
	GameState.last_ignition_quality = ""
	best_km_at_run_start = GameState.best_km
	best_flash_done = false

	$SpawnTimer.timeout.connect(_spawn_obstacle)
	$GasTimer.timeout.connect(_spawn_gas_pickup)
	$FlashTimer.timeout.connect(_flash_wrong_way)

	time_remaining = TIME_BASE_BY_DAY.get(GameState.day, 14.0)
	run_time_max = time_remaining
	road_speed = ROAD_SPEED_START_BY_DAY.get(GameState.day, 74.0)
	$SpawnTimer.wait_time = CAR_SPAWN_WAIT_BY_DAY.get(GameState.day, 2.15)
	$GasTimer.wait_time = GAS_INTERVAL_BY_DAY.get(GameState.day, 4.0)
	_reset_hazard_cooldown()

	wrong_way_label.visible = false
	truck.enabled = false
	igniting = true
	ignition_ready = false
	hold_power = 0.0
	ignition_hold_time = 0.0
	ignition_hint.visible = true
	ignition_hint.text = "Tap space to wake the engine"
	ignition_bar_bg.visible = true
	ignition_zone.visible = true
	ignition_fill.visible = true
	ignition_dim.visible = true
	ignition_dim.color.a = 0.48
	ignition_fill.size.x = 0.0
	var threshold = _ignition_threshold()
	ignition_zone.position.x = 120.0 + threshold * IGNITION_BAR_MAX
	ignition_zone.size.x = (1.0 - threshold) * IGNITION_BAR_MAX
	_update_timer_bar()
	get_tree().create_timer(0.15).timeout.connect(func(): ignition_ready = true)

	_update_hud()
	
	if is_instance_valid(thought_label):
		thought_label.modulate.a = 0

func _build_road_layers():
	road_layer = get_node_or_null("RoadLayer")
	if road_layer == null:
		road_layer = Node2D.new()
		road_layer.name = "RoadLayer"
		add_child(road_layer)
		move_child(road_layer, 0)
	road_layer.z_index = -20
	_setup_scene_road_art()
	_build_speed_lines()

func _setup_scene_road_art():
	var pal = DAY_PALETTE.get(GameState.day, DAY_PALETTE[1])
	_setup_color_rect("RoadLayer/SkyFallback", Vector2.ZERO, Vector2(320, 56), pal["sky"])
	_setup_color_rect("RoadLayer/GrassFallback", Vector2(0, 56), Vector2(320, 88), pal["grass"])
	_setup_color_rect("RoadLayer/LowerGrassFallback", Vector2(0, 144), Vector2(320, 36), pal["grass"].darkened(0.15))
	_setup_sprite_fallback("RoadLayer/SkySprite", "RoadLayer/SkyFallback")

	parallax_layers.clear()
	_setup_sprite_loop("RoadLayer/ParallaxFarA", 0.10, 320.0)
	_setup_sprite_loop("RoadLayer/ParallaxNearA", 0.28, 320.0)

	var road_loop = _setup_sprite_loop("RoadLayer/RoadTiles/RoadTileA", 1.0, ROAD_FALLBACK_TILE_WIDTH)
	road_tiles = road_loop["nodes"]
	road_tile_width = road_loop["width"]
	var has_road_art = not road_tiles.is_empty()
	road_fallback_tiles = _setup_rect_loop("RoadLayer/RoadTiles/RoadFallbackA", ROAD_FALLBACK_TILE_WIDTH, not has_road_art)
	if not has_road_art:
		road_tile_width = ROAD_FALLBACK_TILE_WIDTH

	_build_placeholder_dashes(not has_road_art)

func _build_placeholder_dashes(visible: bool):
	var dash_layer = get_node_or_null("RoadLayer/LaneDashes")
	if dash_layer == null:
		dash_layer = Node2D.new()
		dash_layer.name = "LaneDashes"
		road_layer.add_child(dash_layer)
	if dash_layer.get_child_count() == 0:
		for y in [75, 105]:
			for i in range(12):
				var dash = _make_rect(Vector2(i * 34, y), Vector2(18, 2), Color(0.93, 0.88, 0.62, 1.0), "LaneDash")
				dash_layer.add_child(dash)
				road_dashes.append(dash)
	else:
		road_dashes = dash_layer.get_children()
	for dash in road_dashes:
		dash.visible = visible

func _build_speed_lines():
	speed_lines_layer = Node2D.new()
	speed_lines_layer.z_index = -5
	speed_lines_layer.modulate.a = 0.0
	for i in range(6):
		var sl = _make_rect(Vector2(randf_range(10, 200), randf_range(50, 140)), Vector2(randf_range(30, 60), 2), Color(1, 1, 1, 0.4), "SpeedLine")
		speed_lines_layer.add_child(sl)
	add_child(speed_lines_layer)

func _setup_sprite_loop(source_path: String, speed_scale: float, default_width: float) -> Dictionary:
	var source = get_node_or_null(source_path) as Sprite2D
	if source == null:
		return {"nodes": [], "width": default_width}
	_clear_loop_clones(source)
	var has_art = _sprite_has_texture(source)
	source.visible = has_art
	if not has_art:
		return {"nodes": [], "width": default_width}

	var width = _sprite_width(source, default_width)
	var nodes = [source]
	var parent = source.get_parent()
	var copy_count = max(3, int(ceil(360.0 / width)) + 2)
	for i in range(1, copy_count):
		var clone = source.duplicate()
		clone.name = String(source.name) + "Loop" + str(i)
		clone.position = source.position + Vector2(width * i, 0)
		clone.visible = true
		parent.add_child(clone)
		nodes.append(clone)
	if speed_scale != 1.0:
		parallax_layers.append({"nodes": nodes, "width": width, "speed": speed_scale})
	return {"nodes": nodes, "width": width}

func _setup_rect_loop(source_path: String, width: float, visible: bool) -> Array:
	var source = get_node_or_null(source_path) as ColorRect
	if source == null:
		return []
	_clear_loop_clones(source)
	source.visible = visible
	if not visible:
		return []
	source.size = Vector2(width, source.size.y)
	var nodes = [source]
	var parent = source.get_parent()
	var copy_count = max(3, int(ceil(360.0 / width)) + 2)
	for i in range(1, copy_count):
		var clone = source.duplicate()
		clone.name = String(source.name) + "Loop" + str(i)
		clone.position = source.position + Vector2(width * i, 0)
		clone.visible = true
		parent.add_child(clone)
		nodes.append(clone)
	return nodes

func _setup_sprite_fallback(sprite_path: String, fallback_path: String):
	var sprite = get_node_or_null(sprite_path) as Sprite2D
	var fallback = get_node_or_null(fallback_path)
	if sprite == null:
		return
	var has_texture = _sprite_has_texture(sprite)
	sprite.visible = has_texture
	if fallback != null:
		fallback.visible = not has_texture

func _setup_color_rect(path: String, pos: Vector2, size: Vector2, color: Color):
	var rect = get_node_or_null(path) as ColorRect
	if rect == null:
		return
	rect.position = pos
	rect.size = size
	rect.color = color

func _clear_loop_clones(source: Node):
	var parent = source.get_parent()
	if parent == null:
		return
	var prefix = String(source.name) + "Loop"
	for child in parent.get_children():
		if child != source and String(child.name).begins_with(prefix):
			child.queue_free()

func _sprite_has_texture(sprite: Sprite2D) -> bool:
	return sprite != null and sprite.texture != null

func _sprite_width(sprite: Sprite2D, default_width: float) -> float:
	if not _sprite_has_texture(sprite):
		return default_width
	var width = sprite.texture.get_width() * abs(sprite.scale.x)
	return width if width > 0.0 else default_width

func _make_rect(pos: Vector2, size: Vector2, color: Color, node_name: String) -> ColorRect:
	var rect = ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect

func _build_audio():
	tap_player = AudioStreamPlayer.new()
	hold_player = AudioStreamPlayer.new()
	start_player = AudioStreamPlayer.new()
	tap_player.name = "EngineTapPlayer"
	hold_player.name = "EngineHoldPlayer"
	start_player.name = "EngineStartPlayer"
	tap_player.stream = _make_beep_stream(120.0, 0.08, 0.25)
	hold_player.stream = _make_beep_stream(82.0, 0.18, 0.18)
	start_player.stream = _make_beep_stream(320.0, 0.22, 0.35)
	add_child(tap_player)
	add_child(hold_player)
	add_child(start_player)

func _make_beep_stream(freq: float, duration: float, volume: float) -> AudioStreamWAV:
	var stream = AudioStreamWAV.new()
	var sample_rate = 11025
	var sample_count = int(sample_rate * duration)
	var data = PackedByteArray()
	data.resize(sample_count)
	for i in range(sample_count):
		var t = float(i) / float(sample_rate)
		var wave = sin(t * TAU * freq)
		data[i] = int(clamp(128.0 + wave * 127.0 * volume, 0.0, 255.0))
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = data
	return stream

func _finish_ignition(bonus: int, quality: String):
	GameState.last_ignition_bonus = bonus
	GameState.last_ignition_quality = quality
	time_remaining = min(time_remaining + bonus, TIME_MAX_BY_DAY.get(GameState.day, time_remaining + bonus))
	run_time_max = time_remaining
	_update_timer_bar()

	igniting = false
	ignition_bar_bg.visible = false
	ignition_zone.visible = false
	ignition_fill.visible = false
	ignition_hint.visible = true
	ignition_hint.text = _ignition_success_text(quality, bonus)
	truck.enabled = true
	hold_player.stop()
	start_player.play()
	var dim_tween = create_tween()
	dim_tween.tween_property(ignition_dim, "color:a", 0.0, 0.35)
	dim_tween.finished.connect(func(): ignition_dim.visible = false)
	get_tree().create_timer(0.75).timeout.connect(func():
		if is_instance_valid(ignition_hint):
			ignition_hint.visible = false
	)
	$FlashTimer.start(0.4)
	$SpawnTimer.start()
	$GasTimer.start()
	
	if GameState.day == 1:
		_show_thought(["Okay. Three lanes. Don't panic.", "K makes this look easy. He doesn't, does he."].pick_random())

var _has_shown_low_time = false
var _has_shown_max_speed = false

func _process(delta):
	if igniting:
		_process_ignition(delta)
		return
	if ending:
		return

	drive_elapsed += delta
	_update_road_speed()
	_scroll_road_visuals(delta)
	_update_road_objects_speed()
	_update_drive_km(delta)

	time_remaining -= delta
	time_remaining = max(0.0, time_remaining)
	_update_timer_bar()
	
	if time_remaining > 0 and time_remaining < 5.0 and int(time_remaining) == 4 and not _has_shown_low_time:
		_show_thought(["Come on come ON—", "K owes me so much."].pick_random())
		_has_shown_low_time = true

	hazard_cooldown -= delta
	if GameState.day >= 2 and hazard_cooldown <= 0.0:
		_spawn_road_hazard()
		_reset_hazard_cooldown()

	if time_remaining <= 0:
		ending = true
		_arrive_at_town()

func _process_ignition(delta):
	if not ignition_ready:
		return
	hold_power = max(0.0, hold_power - _ignition_decay() * delta)
	ignition_fill.size.x = hold_power * IGNITION_BAR_MAX
	if hold_power >= _ignition_threshold():
		ignition_hold_time += delta
		ignition_hint.text = "Keep it rumbling..."
		if not hold_player.playing:
			hold_player.play()
		if ignition_hold_time >= _ignition_required_hold():
			var result = _ignition_quality()
			_finish_ignition(result["bonus"], result["quality"])
	else:
		ignition_hold_time = 0.0
		if hold_player.playing:
			hold_player.stop()

func _update_road_speed():
	var start_speed = ROAD_SPEED_START_BY_DAY.get(GameState.day, 74.0)
	var end_speed = ROAD_SPEED_END_BY_DAY.get(GameState.day, 150.0)
	var ramp_time = ROAD_SPEED_RAMP_BY_DAY.get(GameState.day, 18.0)
	speed_progress = clamp(drive_elapsed / ramp_time, 0.0, 1.0)
	road_speed = lerp(start_speed, end_speed, speed_progress)
	truck.set_drive_speed(speed_progress, road_speed)
	
	if road_speed > 115.0:
		var alpha = remap(road_speed, 115.0, 150.0, 0.0, 0.45)
		speed_lines_layer.modulate.a = clamp(alpha, 0.0, 0.45)
		if speed_progress >= 0.99 and not _has_shown_max_speed:
			_show_thought(["...okay. Okay. This is actually fun.", "Don't tell K I'm enjoying this."].pick_random())
			_has_shown_max_speed = true
	else:
		speed_lines_layer.modulate.a = 0.0

func _scroll_road_visuals(delta):
	for tile in road_tiles:
		tile.position.x -= road_speed * delta
		if tile.position.x < -road_tile_width:
			tile.position.x += road_tile_width * road_tiles.size()
	for tile in road_fallback_tiles:
		tile.position.x -= road_speed * delta
		if tile.position.x < -road_tile_width:
			tile.position.x += road_tile_width * road_fallback_tiles.size()
	for dash in road_dashes:
		dash.position.x -= road_speed * delta
		if dash.position.x < -24.0:
			dash.position.x += 408.0
	for layer in parallax_layers:
		for node in layer["nodes"]:
			node.position.x -= road_speed * layer["speed"] * delta
			if node.position.x < -layer["width"]:
				node.position.x += layer["width"] * layer["nodes"].size()
	for sl in speed_lines_layer.get_children():
		sl.position.x -= road_speed * 1.5 * delta
		if sl.position.x < -60.0:
			sl.position.x += 380.0
			sl.position.y = randf_range(50, 140)

func _update_road_objects_speed():
	for node in get_tree().get_nodes_in_group("road_objects"):
		if node.has_method("set_road_speed"):
			node.set_road_speed(road_speed)

func _update_drive_km(delta):
	GameState.drive_km += road_speed * KM_PER_SPEED_SECOND * delta
	GameState.drive_score = int(round(GameState.drive_km * 100.0))
	_check_best_km()
	_update_hud()

func _arrive_at_town():
	$SpawnTimer.stop()
	$GasTimer.stop()
	$FlashTimer.stop()
	town_board.visible = true
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://town_scene.tscn")

func _flash_wrong_way():
	wrong_way_label.visible = !wrong_way_label.visible

func _reset_hazard_cooldown():
	if GameState.day < 2:
		hazard_cooldown = 999.0
		return
	var cooldown_range = HAZARD_COOLDOWN_BY_DAY.get(GameState.day, Vector2(3.0, 4.5))
	hazard_cooldown = randf_range(cooldown_range.x, cooldown_range.y)

func _update_timer_bar():
	var percent = 0.0
	if run_time_max > 0.0:
		percent = clamp(time_remaining / run_time_max, 0.0, 1.0)
	timer_bar.size.x = percent * TIMER_BAR_MAX_WIDTH

func _ignition_threshold() -> float:
	return IGNITION_THRESHOLD_BY_DAY.get(GameState.day, 0.55)

func _ignition_tap_gain() -> float:
	return IGNITION_TAP_GAIN_BY_DAY.get(GameState.day, 0.26)

func _ignition_decay() -> float:
	return IGNITION_DECAY_BY_DAY.get(GameState.day, 0.32)

func _ignition_required_hold() -> float:
	return IGNITION_HOLD_TIME_BY_DAY.get(GameState.day, 0.45)

func _ignition_quality() -> Dictionary:
	var threshold = _ignition_threshold()
	var strength = clamp((hold_power - threshold) / (1.0 - threshold), 0.0, 1.0)
	var bonus = int(round(lerp(float(IGNITION_BONUS_MIN), float(IGNITION_BONUS_MAX), strength)))
	var quality = "bumpy"
	if bonus >= IGNITION_BONUS_MAX:
		quality = "perfect"
	elif bonus >= 2:
		quality = "nice"
	return {"bonus": bonus, "quality": quality}

func _ignition_success_text(quality: String, bonus: int) -> String:
	match quality:
		"perfect":
			return "Perfect start! +" + str(bonus) + "s"
		"nice":
			return "Nice start! +" + str(bonus) + "s"
		_:
			return "Bumpy start! +" + str(bonus) + "s"

func _km_text(km: float) -> String:
	return "%0.2f km" % km

func _spawn_obstacle():
	var active_ambs = get_tree().get_nodes_in_group("ambulance")
	ambulance_spawned = active_ambs.size() > 0
	var active_drunks = get_tree().get_nodes_in_group("drunkard")
	drunkard_spawned = active_drunks.size() > 0

	var r = randf()
	if GameState.day >= 3 and not ambulance_spawned and r < 0.15 and ambulance_scene != null:
		var amb = ambulance_scene.instantiate()
		amb.position = Vector2(340, LANES[randi() % 3])
		amb.truck_ref = truck
		amb.hit.connect(_on_hit)
		amb.near_miss.connect(_on_near_miss)
		add_child(amb)
		_show_thought(["Oh no. Oh no oh no—", "K never mentioned AMBULANCES."].pick_random())
		return

	if GameState.day >= 2 and not drunkard_spawned and r < 0.25 and drunkard_scene != null:
		var drunk = drunkard_scene.instantiate()
		drunk.position = Vector2(340, 90.0)
		drunk.truck_ref = truck
		drunk.hit.connect(_on_hit)
		drunk.near_miss.connect(_on_near_miss)
		add_child(drunk)
		_show_thought(["What is that car DOING.", "Sir. SIR. LANE. CONCEPT."].pick_random())
		return

	var obs = obstacle_scene.instantiate()
	var types = ["car", "scooter", "van"]
	var t = types[randi() % 3]
	var base_speed = 70.0
	match t:
		"car":
			base_speed = 70.0
		"scooter":
			base_speed = 46.0
		"van":
			base_speed = 58.0
	obs.art_key = t
	obs.base_speed = base_speed
	obs.set_road_speed(road_speed)
	obs.position = Vector2(340, LANES[randi() % 3])
	obs.going_right = false
	if randf() < SWERVE_CHANCE.get(GameState.day, 0.0):
		obs.does_swerve = true
	obs.truck_ref = truck
	obs.hit.connect(_on_hit)
	obs.near_miss.connect(_on_near_miss)
	add_child(obs)

func _spawn_gas_pickup():
	if gas_pickup_scene == null:
		return
	var pickup = gas_pickup_scene.instantiate()
	var lane_idx = randi() % 3
	pickup.position = Vector2(340, LANES[lane_idx])
	pickup.lane_index = lane_idx
	if pickup.has_method("set_road_speed"):
		pickup.set_road_speed(road_speed)
	pickup.collected.connect(_on_gas_collected)
	add_child(pickup)

func _spawn_road_hazard():
	if road_hazard_scene == null:
		return
	if GameState.day >= 3 and randf() < 0.55:
		_spawn_ramp_pair()
	else:
		_spawn_hazard("hole", 340.0, randi() % LANES.size())

func _spawn_ramp_pair():
	var lane_idx = randi() % LANES.size()
	_spawn_hazard("ramp", 340.0, lane_idx)
	_spawn_hazard("barricade", 386.0, -1)

func _spawn_hazard(kind: String, x_pos: float, lane_idx: int):
	var hazard = road_hazard_scene.instantiate()
	hazard.kind = kind
	hazard.lane_index = lane_idx
	var y_pos = 90.0 if lane_idx < 0 else LANES[lane_idx]
	hazard.position = Vector2(x_pos, y_pos)
	if hazard.has_method("set_road_speed"):
		hazard.set_road_speed(road_speed)
	hazard.parcel_hit.connect(_on_hit)
	add_child(hazard)

func _on_gas_collected():
	GameState.gas_collected += 1
	time_remaining += 4.0
	run_time_max = max(run_time_max, time_remaining)
	GameState.drive_km += GAS_KM_BONUS
	_check_best_km()
	_update_hud()
	_show_thought(["More time!", "K said grab these. Smart guy actually."].pick_random())

func _check_best_km():
	if GameState.drive_km > GameState.best_km:
		GameState.best_km = GameState.drive_km
		GameState.highscore = int(round(GameState.best_km * 100.0))
		if not best_flash_done and GameState.drive_km > max(best_km_at_run_start, 0.10):
			best_flash_done = true
			_flash_new_record()

func _flash_new_record():
	score_hud_label.modulate = Color(1.0, 0.85, 0.2, 1.0)
	var tween = create_tween()
	tween.tween_property(score_hud_label, "modulate", Color(1, 1, 1, 1), 1.2)

func _unhandled_input(event):
	if igniting:
		if not ignition_ready:
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_accept"):
			hold_power = min(hold_power + _ignition_tap_gain(), 1.0)
			ignition_fill.size.x = hold_power * IGNITION_BAR_MAX
			ignition_hint.text = "Tap tap tap..."
			tap_player.play()
		get_viewport().set_input_as_handled()
		return

func _on_hit():
	# Screen Shake
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_SINE)
	for i in range(4):
		var offset = Vector2(randf_range(-3, 3), randf_range(-3, 3))
		tw.tween_property(hud_layer, "offset", offset, 0.05)
	tw.tween_property(hud_layer, "offset", Vector2.ZERO, 0.05)

	var keys = GameState.inventory.keys().filter(func(k): return GameState.inventory[k] > 0)
	if not keys.is_empty():
		var lost = keys[randi() % keys.size()]
		GameState.inventory[lost] -= 1
		if GameState.inventory[lost] <= 0:
			GameState.inventory.erase(lost)
		_show_thought(["Okay. Okay. That's fine.", "K cannot know about this."].pick_random())
	else:
		_show_thought("...K is absolutely going to know about this.")

	GameState.items = _total_items()
	GameState.near_miss_chain = 0
	_update_hud()

func _on_near_miss():
	GameState.near_miss_chain += 1
	var chain = float(GameState.near_miss_chain)
	var multiplier = 2.0 if Input.is_action_pressed("lean") else 1.0

	var bonus = int(8 * chain * multiplier)
	GameState.near_miss_bonus += bonus
	
	var time_bonus = NEAR_MISS_TIME_BONUS * chain * multiplier
	time_remaining += time_bonus
	run_time_max = max(run_time_max, time_remaining)

	_check_best_km()
	_update_hud()
	_pulse_chain_label()
	
	if GameState.near_miss_chain == 1:
		_show_thought(["That was intentional.", "K would have panicked."].pick_random())
	elif GameState.near_miss_chain == 3:
		_show_thought(["Oh I'm DOING it.", "K is never going to believe this."].pick_random())
	elif GameState.near_miss_chain == 5:
		_show_thought(["I might be better at this than K.", "...don't tell K that."].pick_random())

func _show_thought(text: String):
	if thought_label == null: return
	thought_label.text = text
	var tw = create_tween()
	tw.tween_property(thought_label, "modulate:a", 1.0, 0.3)
	tw.tween_interval(1.2)
	tw.tween_property(thought_label, "modulate:a", 0.0, 0.5)

func _pulse_chain_label():
	if chain_label == null:
		return
	chain_label.pivot_offset = chain_label.size * 0.5
	chain_label.scale = Vector2(1.25, 1.25)
	chain_label.modulate = Color(1.0, 0.86, 0.28, 1.0)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(chain_label, "scale", Vector2.ONE, 0.18)
	tween.tween_property(chain_label, "modulate", Color.WHITE, 0.22)

func _total_items() -> int:
	if GameState.inventory.is_empty():
		return 0
	return GameState.inventory.values().reduce(func(a, b): return a + b, 0)

func _update_hud():
	var count = _total_items()
	for i in range(parcel_icons.size()):
		if i < count:
			parcel_icons[i].modulate = Color(1, 1, 1, 1)
		else:
			parcel_icons[i].modulate = Color(0.3, 0.3, 0.3, 1)
	var chain = GameState.near_miss_chain
	chain_label.visible = chain > 0
	chain_label.text = "🔥 x" + str(chain)
	score_hud_label.text = _km_text(GameState.drive_km)
