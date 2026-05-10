extends Area2D

signal hit
signal near_miss

# Sine-wave oscillator across all 3 lanes — unpredictable but learnable
const LANES = [60.0, 90.0, 120.0]
const WOBBLE_AMP = 32.0   # reaches top/bottom lane fully at peak

var road_speed = 70.0
var truck_ref = null
var hit_truck = false
var was_near_truck = false

var time_alive: float = 0.0
var wobble_freq: float    # randomized per-instance for variety
var wobble_phase: float   # randomized offset

func _ready():
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)
	wobble_freq  = randf_range(0.55, 1.15)
	wobble_phase = randf() * TAU

func set_road_speed(value: float):
	road_speed = value

func _process(delta):
	time_alive += delta
	# Slow horizontal movement — about 40% of road speed
	position.x -= road_speed * 0.40 * delta
	# Mid-lane centre with sine wobble across all 3 lanes
	position.y = 90.0 + sin(time_alive * wobble_freq + wobble_phase) * WOBBLE_AMP

	# Near-miss detection
	if truck_ref and not hit_truck:
		if abs(position.x - truck_ref.position.x) < 30 and \
		   abs(position.y - truck_ref.position.y) < 20:
			was_near_truck = true

	if position.x < -32:
		if truck_ref and not hit_truck and was_near_truck:
			near_miss.emit()
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("truck"):
		hit_truck = true
		hit.emit()
		queue_free()
