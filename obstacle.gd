extends Area2D

signal hit

var speed = 80.0

func _ready():
	body_entered.connect(_on_body_entered)
	
func _process(delta):
	position.x -= speed * delta
	if position.x < -32:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("truck"):
		hit.emit()
		queue_free()
