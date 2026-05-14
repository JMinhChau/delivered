extends Area2D

signal hit
signal near_miss

const LANES = [60.0, 90.0, 120.0]
const SWERVE_INTERVAL = 1.5
const MOVE_SPEED = 55.0
const AVOID_DIST = 40.0
const DODGE_ARM_DISTANCE = 112.0
const SAME_LANE_TOLERANCE = 14.0
const DODGED_LANE_TOLERANCE = 22.0
const ROAD_DEPTH_BASE = 100
const SIZE_BY_KEY = {
	"car": Vector2(18, 10),
	"scooter": Vector2(14, 10),
	"van": Vector2(22, 12),
}
const FALLBACK_COLOR_BY_KEY = {
	"car": Color(0.75, 0.82, 0.95, 1),
	"scooter": Color(0.6, 0.9, 0.6, 1),
	"van": Color(0.9, 0.5, 0.2, 1),
}

var speed = 80.0
var base_speed = 80.0
var truck_ref = null
var hit_truck = false
var near_miss_emitted = false
var near_miss_armed = false
var armed_truck_lane = -1
var armed_threat_y = 0.0
var going_right = false
var does_swerve = false
var target_y: float
var swerve_timer = 0.0
var avoid_timer = 0.0
var art_key = "car"

@onready var sprite = $Sprite2D
@onready var fallback_body = $Fallback/Body

func _ready():
	add_to_group("obstacles")
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)
	target_y = position.y
	_apply_art()
	_update_depth()

func set_road_speed(value: float):
	speed = base_speed + value * 0.55

func _apply_art():
	var target_size = SIZE_BY_KEY.get(art_key, SIZE_BY_KEY["car"])
	fallback_body.color = FALLBACK_COLOR_BY_KEY.get(art_key, FALLBACK_COLOR_BY_KEY["car"])
	fallback_body.offset_left = -target_size.x * 0.5
	fallback_body.offset_top = -target_size.y * 0.5
	fallback_body.offset_right = target_size.x * 0.5
	fallback_body.offset_bottom = target_size.y * 0.5
	var has_sprite_art = sprite.texture != null
	sprite.visible = has_sprite_art
	$Fallback.visible = not has_sprite_art

func _process(delta):
	if abs(position.y - target_y) > 0.5:
		position.y = move_toward(position.y, target_y, MOVE_SPEED * delta)
	_update_depth()

	if does_swerve:
		swerve_timer += delta
		if swerve_timer >= SWERVE_INTERVAL:
			swerve_timer = 0.0
			var opts = LANES.filter(func(l): return abs(l - target_y) > 15.0)
			if not opts.is_empty():
				target_y = opts[randi() % opts.size()]

	avoid_timer += delta
	if avoid_timer >= 0.25:
		avoid_timer = 0.0
		_check_avoid()

	if going_right:
		position.x += speed * delta
	else:
		position.x -= speed * delta

	_check_near_miss()

	var past_bounds = position.x > 360 if going_right else position.x < -32
	if past_bounds:
		queue_free()

func _check_near_miss():
	if truck_ref == null or hit_truck or near_miss_emitted:
		return

	var distance_to_truck = _distance_to_truck()
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

func _distance_to_truck() -> float:
	if going_right:
		return truck_ref.position.x - position.x
	return position.x - truck_ref.position.x

func _check_avoid():
	if abs(position.y - target_y) > 1.0:
		return

	# Priority 1: flee from ambulances in same lane
	for amb in get_tree().get_nodes_in_group("ambulance"):
		if not is_instance_valid(amb):
			continue
		var same_lane = abs(amb.position.y - position.y) < 18.0
		var amb_incoming = amb.position.x > position.x  # ambulance is still approaching
		if same_lane and amb_incoming:
			var opts = LANES.filter(func(l): return abs(l - target_y) > 15.0)
			if not opts.is_empty():
				target_y = opts[randi() % opts.size()]
			return  # handled, skip normal avoid

	# Priority 2: normal obstacle avoidance
	for other in get_tree().get_nodes_in_group("obstacles"):
		if other == self:
			continue
		var same_lane = abs(other.position.y - position.y) < 15.0
		var is_ahead = other.position.x < position.x if not going_right else other.position.x > position.x
		var too_close = abs(other.position.x - position.x) < AVOID_DIST
		if same_lane and is_ahead and too_close:
			var opts = LANES.filter(func(l): return abs(l - target_y) > 15.0)
			if not opts.is_empty():
				target_y = opts[randi() % opts.size()]
			break

func _on_body_entered(body):
	if body.is_in_group("truck"):
		hit_truck = true
		hit.emit()
		queue_free()

func _update_depth():
	z_index = ROAD_DEPTH_BASE + int(round(position.y))
