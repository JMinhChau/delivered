extends CharacterBody2D

const LANES = [60, 90, 120]
const JUMP_HEIGHT = 18.0
const JUMP_TIME = 0.85

var lane = 1
var items = 5
var is_tweening = false
var enabled = true
var is_airborne = false

func _ready():
	position.y = LANES[lane]
	add_to_group("truck")

func _process(delta):
	var lean = enabled and Input.is_action_pressed("lean")
	var target_x = 2.0 if lean else 0.0
	$Sprite2D.position.x = move_toward($Sprite2D.position.x, target_x, 30.0 * delta)

func _unhandled_input(event):
	if not enabled or is_tweening:
		return
	if event.is_action_pressed("ui_up") and lane > 0:
		lane -= 1
		_slide_to_lane()
	elif event.is_action_pressed("ui_down") and lane < LANES.size() - 1:
		lane += 1
		_slide_to_lane()

func force_lane_shift(direction: int):
	var next_lane = clamp(lane + direction, 0, LANES.size() - 1)
	if next_lane == lane:
		next_lane = clamp(lane - direction, 0, LANES.size() - 1)
	if next_lane == lane:
		return
	lane = next_lane
	is_tweening = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", LANES[lane], 0.14)
	tween.finished.connect(func(): is_tweening = false)

func jump():
	if is_airborne:
		return
	is_airborne = true
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property($Sprite2D, "position:y", -JUMP_HEIGHT, JUMP_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "position:y", 0.0, JUMP_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): is_airborne = false)

func _slide_to_lane():
	is_tweening = true
	var tween = create_tween()
	var lean = Input.is_action_pressed("lean")
	if lean or GameState.day == 1:
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:y", LANES[lane], 0.16 if lean else 0.20)
	else:
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:y", LANES[lane], 0.24)
	tween.finished.connect(func(): is_tweening = false)
