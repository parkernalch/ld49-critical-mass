extends Node2D
class_name Neutron

var speed : float = 1.0

func _process(delta):
	transform.origin = transform.origin + Vector2(0, speed)
	pass

func collect(target : Node):
	queue_free()
	pass
