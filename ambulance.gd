extends Area2D

signal hit
signal near_miss

# Fast, straight, causes nearby cars to scatter out of its lane
const SIREN_INTERVAL = 0.28
const DODGE_ARM_DISTANCE = 112.0
const SAME_LANE_TOLERANCE = 14.0
const DODGED_LANE_TOLERANCE = 22.0
const ROAD_DEPTH_BASE = 100

var road_speed = 70.0
var truck_ref = null
var hit_truck = false
var near_miss_emitted = false
var near_miss_armed = false
var armed_truck_lane = -1
var armed_threat_y = 0.0
var siren_timer = 0.0
var siren_on = false

@onready var siren_rect = $Fallback/SirenRect
@onready var sprite = $Sprite2D
@onready var fallback = $Fallback

func _ready():
	add_to_group("ambulance")
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)
	_apply_art()
	_update_depth()

func set_road_speed(value: float):
	# Always significantly faster than normal traffic
	road_speed = value + 50.0

func _apply_art():
	var has_sprite_art = sprite.texture != null
	sprite.visible = has_sprite_art
	fallback.visible = not has_sprite_art

func _process(delta):
	position.x -= road_speed * delta
	_update_depth()

	# Flashing siren (visual only, no audio asset needed)
	siren_timer += delta
	if siren_timer >= SIREN_INTERVAL:
		siren_timer = 0.0
		siren_on = !siren_on
		siren_rect.color = Color(1.0, 0.12, 0.12, 1.0) if siren_on \
			else Color(0.85, 0.85, 0.85, 1.0)

	_check_near_miss()

	if position.x < -32:
		queue_free()

func _check_near_miss():
	if truck_ref == null or hit_truck or near_miss_emitted:
		return

	var distance_to_truck = position.x - truck_ref.position.x
	var same_lane = abs(position.y - truck_ref.position.y) <= SAME_LANE_TOLERANCE
	if not near_miss_armed and distance_to_truck > 0.0 and distance_to_truck <= DODGE_ARM_DISTANCE and same_lane:
		near_miss_armed = true
		armed_truck_lane = truck_ref.lane
		armed_threat_y = truck_ref.position.y

	if near_miss_armed and distance_to_truck > 0.0:
		var changed_lane = truck_ref.lane != armed_truck_lane
		var cleared_lane = abs(truck_ref.position.y - armed_threat_y) >= DODGED_LANE_TOLERANCE
		var threat_stayed_in_lane = abs(position.y - armed_threat_y) <= DODGED_LANE_TOLERANCE
		if not changed_lane or not cleared_lane or not threat_stayed_in_lane:
			return
		near_miss_emitted = true
		near_miss.emit()

func _on_body_entered(body):
	if body.is_in_group("truck"):
		hit_truck = true
		hit.emit()
		queue_free()

func _update_depth():
	z_index = ROAD_DEPTH_BASE + int(round(position.y))
