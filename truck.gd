extends CharacterBody2D

const LANES = [60, 90, 120]
const JUMP_HEIGHT = 18.0
const JUMP_TIME = 0.85

# Learner driver: delay before lane change starts (fades with days)
const INPUT_DELAY_BY_DAY  = {1: 0.22, 2: 0.16, 3: 0.11, 4: 0.07, 5: 0.04}
# Tween duration for player-initiated slides
const SLIDE_DURATION_BY_DAY = {1: 0.38, 2: 0.30, 3: 0.24, 4: 0.18, 5: 0.14}
# Hole force-shift drift duration (sluggish, uncontrolled)
const HOLE_DRIFT_BY_DAY   = {1: 0.42, 2: 0.36, 3: 0.30, 4: 0.24, 5: 0.20}

var lane = 1
var items = 5
var is_tweening = false
var enabled = true
var is_airborne = false

# Pending lane change (input delay system)
var pending_lane: int = -1
var input_delay_timer: float = 0.0

func _ready():
	position.y = LANES[lane]
	add_to_group("truck")

func _process(delta):
	# Lean sprite sway (cosmetic only, no speed effect)
	var lean = enabled and Input.is_action_pressed("lean")
	var target_x = 2.0 if lean else 0.0
	$Sprite2D.position.x = move_toward($Sprite2D.position.x, target_x, 30.0 * delta)

	# Countdown for pending lane change
	if pending_lane >= 0:
		input_delay_timer -= delta
		if input_delay_timer <= 0.0:
			var target = pending_lane
			pending_lane = -1
			_execute_slide(target)

func _unhandled_input(event):
	# Block input while tweening OR while a change is already pending
	if not enabled or is_tweening or pending_lane >= 0:
		return
	if event.is_action_pressed("ui_up") and lane > 0:
		pending_lane = lane - 1
		input_delay_timer = INPUT_DELAY_BY_DAY.get(GameState.day, 0.04)
	elif event.is_action_pressed("ui_down") and lane < LANES.size() - 1:
		pending_lane = lane + 1
		input_delay_timer = INPUT_DELAY_BY_DAY.get(GameState.day, 0.04)

func _execute_slide(target_lane: int):
	lane = target_lane
	is_tweening = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", LANES[lane],
		SLIDE_DURATION_BY_DAY.get(GameState.day, 0.14))
	tween.finished.connect(func(): is_tweening = false)

func force_lane_shift(direction: int):
	var next_lane = clamp(lane + direction, 0, LANES.size() - 1)
	if next_lane == lane:
		next_lane = clamp(lane - direction, 0, LANES.size() - 1)
	if next_lane == lane:
		return
	lane = next_lane
	pending_lane = -1  # cancel any queued input
	is_tweening = true
	var tween = create_tween()
	# Sine ease-in-out: slow start + slow end = feels like inertia/drift
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", LANES[lane],
		HOLE_DRIFT_BY_DAY.get(GameState.day, 0.20))
	tween.finished.connect(func(): is_tweening = false)

func jump():
	if is_airborne:
		return
	is_airborne = true
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property($Sprite2D, "position:y", -JUMP_HEIGHT, JUMP_TIME * 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "position:y", 0.0, JUMP_TIME * 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): is_airborne = false)
