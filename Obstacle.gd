extends KinematicBody2D
class_name Obstacle

var angular_velocity : float = 0.0
var relative_velocity : Vector2 = Vector2.DOWN
var repulse_vector : Vector2 = Vector2.ZERO

func _ready():
	rotation_degrees = rand_range(0, 180)
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	add_to_group('obstacles')
	$Sprite.self_modulate = Color("#5a4c3e");
	pass

func set_angular_velocity(vel):
	angular_velocity = vel
	
func set_velocity(vel):
	relative_velocity = vel

func set_size(_size):
	$Sprite.scale = Vector2(_size, _size)
	$Collider.scale = Vector2(_size, _size)

func _physics_process(delta):
	if repulse_vector == Vector2.ZERO:
		rotation_degrees += angular_velocity * delta
		move_and_collide(relative_velocity + Vector2.DOWN * Global.travel_speed)
	else:
		rotation_degrees += angular_velocity * delta * 5.0
		move_and_collide(repulse_vector)

func _on_ship_wasDestroyed():
	set_physics_process(false)
	Events.connect("StartGame", self, "queue_free")

func repulse(direction, magnitude):
	repulse_vector = direction * magnitude
	
