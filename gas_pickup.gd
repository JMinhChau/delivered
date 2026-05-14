extends Area2D

signal collected

const LIFETIME_LEFT = -32.0
const BOB_SPEED = 8.0
const BOB_AMOUNT = 3.0
const PICKUP_DEPTH = 500

var lane_index: int = 0
var road_speed = 70.0
var collected_once = false
var base_y = 0.0
var bob_time = 0.0
var base_sprite_scale = Vector2.ONE

@onready var sprite = $Sprite2D

func _ready():
	add_to_group("gas_pickups")
	add_to_group("road_objects")
	z_index = PICKUP_DEPTH
	base_y = position.y
	body_entered.connect(_on_body_entered)
	if sprite.has_method("refresh"):
		sprite.call("refresh")
	base_sprite_scale = sprite.scale

func set_road_speed(value: float):
	road_speed = value

func _process(delta):
	if collected_once:
		return
	position.x -= road_speed * delta
	bob_time += delta
	position.y = base_y + sin(bob_time * BOB_SPEED) * BOB_AMOUNT
	sprite.rotation += 8.0 * delta
	sprite.scale = base_sprite_scale * (1.0 + 0.18 * sin(bob_time * BOB_SPEED))
	if position.x < LIFETIME_LEFT:
		queue_free()

func collect():
	if collected_once:
		return
	collected_once = true
	collected.emit()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", base_sprite_scale * 2.4, 0.12)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.12)
	await tween.finished
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("truck"):
		collect()
