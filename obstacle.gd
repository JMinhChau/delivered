extends Area2D

signal hit
signal near_miss

const LANES = [60.0, 90.0, 120.0]
const SWERVE_INTERVAL = 1.5
const MOVE_SPEED = 55.0
const AVOID_DIST = 40.0

var speed = 80.0
var truck_ref = null
var hit_truck = false
var was_near_truck = false
var going_right = false
var does_swerve = false
var target_y: float
var swerve_timer = 0.0
var avoid_timer = 0.0

func _ready():
	add_to_group("obstacles")
	body_entered.connect(_on_body_entered)
	target_y = position.y

func _process(delta):
	if abs(position.y - target_y) > 0.5:
		position.y = move_toward(position.y, target_y, MOVE_SPEED * delta)

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

	if truck_ref and not hit_truck:
		if abs(position.x - truck_ref.position.x) < 30 and abs(position.y - truck_ref.position.y) < 20:
			was_near_truck = true

	var past_bounds = position.x > 360 if going_right else position.x < -32
	if past_bounds:
		if truck_ref and not hit_truck and was_near_truck:
			near_miss.emit()
		queue_free()

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
