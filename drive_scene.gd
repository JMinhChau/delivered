extends Node2D

@export var obstacle_scene: PackedScene

const LANES = [60, 90, 120]
const TIMER_BAR_MAX_WIDTH = 60.0

var time_remaining = 20.0

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

func _ready():
	GameState.near_miss_chain = 0
	$SpawnTimer.timeout.connect(_spawn_obstacle)

	if GameState.drive_mode == "return":
		$SpawnTimer.wait_time = 2.5
		wrong_way_label.visible = false
		truck.get_node("Sprite2D").flip_h = true
	else:
		$FlashTimer.timeout.connect(_flash_wrong_way)
		$FlashTimer.start(0.4)

	_update_hud()

	if GameState.drive_mode == "to_town":
		get_tree().create_timer(20.0).timeout.connect(func():
			get_tree().change_scene_to_file("res://town_scene.tscn"))
	else:
		get_tree().create_timer(20.0).timeout.connect(func():
			get_tree().change_scene_to_file("res://salary_scene.tscn"))

func _process(delta):
	time_remaining -= delta
	time_remaining = max(0.0, time_remaining)
	timer_bar.size.x = (time_remaining / 20.0) * TIMER_BAR_MAX_WIDTH

func _flash_wrong_way():
	wrong_way_label.visible = !wrong_way_label.visible

func _spawn_obstacle():
	var obs = obstacle_scene.instantiate()

	var types = ["car", "scooter", "van"]
	var t = types[randi() % 3]
	match t:
		"car":
			obs.speed = 80.0
		"scooter":
			obs.speed = 40.0
			obs.modulate = Color(0.6, 0.9, 0.6)
		"van":
			obs.speed = 60.0
			obs.modulate = Color(0.9, 0.5, 0.2)

	if GameState.drive_mode == "return":
		obs.position = Vector2(-32, LANES[randi() % 3])
		obs.going_right = true
		obs.speed = obs.speed * 0.45
	else:
		obs.position = Vector2(340, LANES[randi() % 3])
		obs.going_right = false

	obs.truck_ref = truck
	obs.hit.connect(_on_hit)
	obs.near_miss.connect(_on_near_miss)
	add_child(obs)

func _on_hit():
	var keys = GameState.inventory.keys().filter(func(k): return GameState.inventory[k] > 0)
	if not keys.is_empty():
		var lost = keys[randi() % keys.size()]
		GameState.inventory[lost] -= 1
		if GameState.inventory[lost] <= 0:
			GameState.inventory.erase(lost)
	GameState.items = _total_items()
	GameState.near_miss_chain = 0
	_update_hud()

func _on_near_miss():
	GameState.near_miss_chain += 1
	var bonus = 10 * GameState.near_miss_chain
	GameState.near_miss_bonus += bonus
	_update_hud()

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
