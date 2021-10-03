extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	pass

func _on_body_entered(body):
	if body is Neutron or body is Obstacle:
		body.queue_free()
