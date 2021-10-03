extends KinematicBody2D
class_name Obstacle

var angular_velocity : float = 0.0
var repulse_vector : Vector2 = Vector2.ZERO

func _ready():
	rotation_degrees = rand_range(0, 180)
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	add_to_group('obstacles')
	pass

func _physics_process(delta):
	if repulse_vector == Vector2.ZERO:
		rotation_degrees += angular_velocity * delta
		move_and_collide(Vector2.DOWN * Global.travel_speed)
	else:
		rotation_degrees += angular_velocity * delta * 5.0
		move_and_collide(repulse_vector)

func _on_ship_wasDestroyed():
	set_physics_process(false)
	Events.connect("StartGame", self, "queue_free")

func repulse(direction, magnitude):
	repulse_vector = direction * magnitude
	
