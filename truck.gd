extends CharacterBody2D

const LANES = [60, 90, 120]
const JUMP_HEIGHT = 18.0
const JUMP_TIME = 0.85

# Tween duration for player-initiated slides (sluggish start)
const SLIDE_DURATION_BY_DAY = {1: 0.60, 2: 0.45, 3: 0.35, 4: 0.25, 5: 0.18}
# Hole force-shift drift duration (sluggish, uncontrolled)
const HOLE_DRIFT_BY_DAY   = {1: 0.55, 2: 0.48, 3: 0.40, 4: 0.32, 5: 0.25}

var lane = 1
var items = 5
var is_tweening = false
var enabled = true
var is_airborne = false

var current_tween: Tween

func _ready():
	position.y = LANES[lane]
	add_to_group("truck")

func _process(delta):
	# Lean sprite sway (cosmetic only, no speed effect)
	var lean = enabled and Input.is_action_pressed("lean")
	var target_x = 2.0 if lean else 0.0
	$Sprite2D.position.x = move_toward($Sprite2D.position.x, target_x, 30.0 * delta)

func _unhandled_input(event):
	# Allow input even if tweening to prevent "delayed" feeling on subsequent taps
	if not enabled:
		return
	if event.is_action_pressed("ui_up") and lane > 0:
		_execute_slide(lane - 1)
	elif event.is_action_pressed("ui_down") and lane < LANES.size() - 1:
		_execute_slide(lane + 1)

func _execute_slide(target_lane: int):
	lane = target_lane
	is_tweening = true
	
	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_SINE)
	current_tween.set_ease(Tween.EASE_IN_OUT)
	current_tween.tween_property(self, "position:y", LANES[lane],
		SLIDE_DURATION_BY_DAY.get(GameState.day, 0.18))
	current_tween.finished.connect(func(): is_tweening = false)

func force_lane_shift(direction: int):
	var next_lane = clamp(lane + direction, 0, LANES.size() - 1)
	if next_lane == lane:
		next_lane = clamp(lane - direction, 0, LANES.size() - 1)
	if next_lane == lane:
		return
	lane = next_lane
	is_tweening = true
	
	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.set_parallel(true)
	
	# Sine ease-in-out: slow start + slow end = feels like inertia/drift
	var duration = HOLE_DRIFT_BY_DAY.get(GameState.day, 0.25)
	current_tween.tween_property(self, "position:y", LANES[lane], duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	# 360 flip
	var current_rot = $Sprite2D.rotation
	current_tween.tween_property($Sprite2D, "rotation", current_rot + TAU, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	current_tween.finished.connect(func(): 
		is_tweening = false
		$Sprite2D.rotation = fmod($Sprite2D.rotation, TAU)
	)

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
