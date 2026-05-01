extends Area2D

signal hit
signal near_miss

var speed = 80.0
var truck_ref = null
var hit_truck = false
var was_near_truck = false
var going_right = false

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
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

func _on_body_entered(body):
	if body.is_in_group("truck"):
		hit_truck = true
		hit.emit()
		queue_free()
