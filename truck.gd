extends CharacterBody2D

const LANES = [60, 90, 120]
var lane = 1
var items = 5
var is_tweening = false

func _ready():
	position.y = LANES[lane]
	add_to_group("truck")

func _unhandled_input(event):
	if is_tweening:
		return
	if event.is_action_pressed("ui_up") and lane > 0:
		lane -= 1
		_slide_to_lane()
	elif event.is_action_pressed("ui_down") and lane < LANES.size() - 1:
		lane += 1
		_slide_to_lane()

func _slide_to_lane():
	is_tweening = true
	var tween = create_tween()
	tween.tween_property(self, "position:y", LANES[lane], 0.1)
	tween.finished.connect(func(): is_tweening = false)
