extends Area2D

signal hit
signal near_miss

# Fast, straight, causes nearby cars to scatter out of its lane
const SIREN_INTERVAL = 0.28

var road_speed = 70.0
var truck_ref = null
var hit_truck = false
var was_near_truck = false
var siren_timer = 0.0
var siren_on = false

@onready var siren_rect = $SirenRect

func _ready():
	add_to_group("ambulance")
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)

func set_road_speed(value: float):
	# Always significantly faster than normal traffic
	road_speed = value + 50.0

func _process(delta):
	position.x -= road_speed * delta

	# Flashing siren (visual only, no audio asset needed)
	siren_timer += delta
	if siren_timer >= SIREN_INTERVAL:
		siren_timer = 0.0
		siren_on = !siren_on
		siren_rect.color = Color(1.0, 0.12, 0.12, 1.0) if siren_on \
			else Color(0.85, 0.85, 0.85, 1.0)

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
