extends Area2D

signal parcel_hit
signal used(kind: String)

const LIFETIME_LEFT = -36.0
const ART_BY_KIND = {
	"hole": "res://art/drive/hole.png",
	"ramp": "res://art/drive/ramp.png",
	"barricade": "res://art/drive/barricade.png",
}
const SIZE_BY_KIND = {
	"hole": Vector2(18, 14),
	"ramp": Vector2(18, 14),
	"barricade": Vector2(20, 76),
}
const ROAD_DEPTH_BASE = 100
const ROAD_SURFACE_DEPTH_OFFSET = -8
const BARRICADE_DEPTH_Y = 125.0

var kind = "hole"
var lane_index = 0
var road_speed = 70.0
var used_once = false

@onready var visual = $Fallback/Visual
@onready var symbol = $Fallback/Symbol
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	add_to_group("road_objects")
	body_entered.connect(_on_body_entered)
	_apply_kind_visual()
	_update_depth()

func set_road_speed(value: float):
	road_speed = value

func _process(delta):
	position.x -= road_speed * delta
	_update_depth()
	if position.x < LIFETIME_LEFT:
		queue_free()

func _apply_kind_visual():
	var target_size = SIZE_BY_KIND.get(kind, SIZE_BY_KIND["hole"])
	match kind:
		"ramp":
			visual.color = Color(0.86, 0.64, 0.32, 1.0)
			symbol.text = "/"
		"barricade":
			visual.color = Color(0.92, 0.32, 0.24, 1.0)
			visual.offset_left = -10.0
			visual.offset_top = -38.0
			visual.offset_right = 10.0
			visual.offset_bottom = 38.0
			var shape = RectangleShape2D.new()
			shape.size = Vector2(20, 76)
			collision_shape.shape = shape
			symbol.offset_top = -8.0
			symbol.offset_bottom = 8.0
			symbol.text = "!"
		_:
			visual.color = Color(0.05, 0.04, 0.04, 1.0)
			symbol.text = "O"
	sprite.set("texture_path", ART_BY_KIND.get(kind, ART_BY_KIND["hole"]))
	sprite.set("target_size", target_size)
	sprite.call("refresh")
	_update_depth()

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

func _update_depth():
	if kind == "barricade":
		z_index = ROAD_DEPTH_BASE + int(round(BARRICADE_DEPTH_Y))
	else:
		z_index = ROAD_DEPTH_BASE + int(round(position.y)) + ROAD_SURFACE_DEPTH_OFFSET
