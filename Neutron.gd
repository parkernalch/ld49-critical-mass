extends KinematicBody2D
class_name Neutron

var speed : float = 1.0
var composite_speed : float = 1.0
var size : int = 2
onready var sprite = $Sprite
var angular_velocity

var target

func _ready():
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	set_size(rand_range(1, 4))

func _process(delta):
	if not target:
		composite_speed = Global.travel_speed * speed
		move_and_collide(Vector2.DOWN * composite_speed)
	else:
		if not target:
			return
		var direction : Vector2 = (target.transform.origin - transform.origin).normalized()
		move_and_collide(direction * 300.0 * delta)
	pass

func set_size(new_size : int):
	size = new_size
	match new_size:
		1:
			$Sprite.scale = Vector2(0.15, 0.15)
		2:
			$Sprite.scale = Vector2(0.25, 0.25)
		3:
			$Sprite.scale = Vector2(0.35, 0.35)

func collect(_target : Node):
	target = _target
	pass

func _on_ship_wasDestroyed():
	speed = 0.0
	set_physics_process(false)
	Events.connect("StartGame", self, "queue_free")
