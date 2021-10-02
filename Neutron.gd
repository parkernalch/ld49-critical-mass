extends Node2D
class_name Neutron

var speed : float = 1.0
var composite_speed : float = 1.0
var size : int = 1

func _process(delta):
	composite_speed = Global.travel_speed * speed
	transform.origin = transform.origin + Vector2(0, composite_speed)
	pass

func collect(target : Node):
	queue_free()
	pass
