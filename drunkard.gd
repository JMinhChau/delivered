extends Area2D

signal hit
signal near_miss

const LANES = [60.0, 90.0, 120.0]
const LANE_DRIFT_SPEED = 85.0
const LANE_CHANGE_INTERVAL = 0.65
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

var time_alive: float = 0.0
var lane_timer = 0.0
var target_lane = 1

@onready var sprite = $Sprite2D
@onready var fallback = $Fallback

func _ready():
	add_to_group("drunkard")
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)
	target_lane = 1
	_apply_art()
	_update_depth()

func set_road_speed(value: float):
	road_speed = value

func _apply_art():
	var has_sprite_art = sprite.texture != null
	sprite.visible = has_sprite_art
	fallback.visible = not has_sprite_art

func _process(delta):
	time_alive += delta
	position.x -= road_speed * 0.95 * delta

	lane_timer -= delta
	if lane_timer <= 0.0:
		lane_timer = randf_range(LANE_CHANGE_INTERVAL * 0.7, LANE_CHANGE_INTERVAL * 1.35)
		target_lane = clamp(target_lane + ([-1, 0, 1].pick_random()), 0, LANES.size() - 1)
	position.y = move_toward(position.y, LANES[target_lane], LANE_DRIFT_SPEED * delta)
	_update_depth()

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
