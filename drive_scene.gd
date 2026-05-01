extends Node2D

@export var obstacle_scene: PackedScene

const LANES = [60, 90, 120]

@onready var truck = $Truck
@onready var item_label = $HUD/ItemLabel

func _ready():
	print("Drive mode: ", GameState.drive_mode)  # ← add this
	truck.items = GameState.items
	item_label.text = "Items: " + str(truck.items)
	$SpawnTimer.timeout.connect(_spawn_obstacle)
	
	if GameState.drive_mode == "return":
		$SpawnTimer.wait_time = 2.5
	
	var next = "res://town_scene.tscn" if GameState.drive_mode == "to_town" else "res://salary_scene.tscn"
	get_tree().create_timer(20.0).timeout.connect(func(): get_tree().change_scene_to_file(next))

func _spawn_obstacle():
	var obs = obstacle_scene.instantiate()
	obs.position = Vector2(340, LANES[randi() % 3])
	if GameState.drive_mode == "return":
		obs.speed = 50.0
	obs.hit.connect(_on_hit)
	add_child(obs)

func _on_hit():
	truck.items = max(0, truck.items - 1)
	GameState.items = truck.items
	item_label.text = "Items: " + str(truck.items)
