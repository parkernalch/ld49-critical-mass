extends KinematicBody2D
class_name Pickup

enum PICKUP {
	HEALTH,
	SHIELD,
}

var value : int = 1
var type : int
var target

func _process(delta):
	if not target:
		move_and_collide(Vector2.DOWN * Global.travel_speed)
	else:
		if not target:
			return
		var direction : Vector2 = (target.transform.origin - transform.origin).normalized()
		move_and_collide(direction * 300.0 * delta)
	pass

func pickup(_target : Node2D):
	Events.emit_signal("PickupAcquired", type, value)
	target = _target
	call_deferred("queue_free", 0.25)
	
