extends CharacterBody2D

const LANES = [60, 90, 120]
var lane = 1
var items = 5

func _ready():
	position.y = LANES[lane]
	add_to_group("truck")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_up") and lane > 0:
		lane -= 1
		position.y = LANES[lane]
	elif event.is_action_pressed("ui_down") and lane < LANES.size() - 1:
		lane += 1
		position.y = LANES[lane]
