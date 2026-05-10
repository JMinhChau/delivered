extends Area2D

signal parcel_hit
signal used(kind: String)

const LIFETIME_LEFT = -36.0

var kind = "hole"
var lane_index = 0
var road_speed = 70.0
var used_once = false

@onready var visual = $Visual
@onready var symbol = $Symbol

func _ready():
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)
	_apply_kind_visual()

func set_road_speed(value: float):
	road_speed = value

func _process(delta):
	position.x -= road_speed * delta
	if position.x < LIFETIME_LEFT:
		queue_free()

func _apply_kind_visual():
	match kind:
		"ramp":
			visual.color = Color(0.86, 0.64, 0.32, 1.0)
			symbol.text = "/"
		"barricade":
			visual.color = Color(0.92, 0.32, 0.24, 1.0)
			symbol.text = "!"
		_:
			visual.color = Color(0.05, 0.04, 0.04, 1.0)
			symbol.text = "O"

func _on_body_entered(body):
	if used_once or not body.is_in_group("truck"):
		return
	used_once = true
	match kind:
		"hole":
			var direction = 1
			if lane_index >= 2:
				direction = -1
			elif lane_index == 1:
				direction = -1 if randf() < 0.5 else 1
			body.force_lane_shift(direction)
			used.emit(kind)
			queue_free()
		"ramp":
			body.jump()
			used.emit(kind)
			queue_free()
		"barricade":
			if body.is_airborne:
				used.emit("clear")
			else:
				parcel_hit.emit()
				used.emit(kind)
			queue_free()
