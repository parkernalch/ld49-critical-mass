extends KinematicBody2D
class_name Obstacle

var angular_velocity : float = 0.0

func _ready():
	rotation_degrees = rand_range(0, 180)
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	pass

func _physics_process(delta):
	rotation_degrees += angular_velocity * delta
	move_and_collide(Vector2.DOWN * Global.travel_speed)

func _on_ship_wasDestroyed():
	set_physics_process(false)
	Events.connect("StartGame", self, "queue_free")
