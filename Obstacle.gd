extends KinematicBody2D
class_name Obstacle

func _ready():
	rotation_degrees = rand_range(0, 180)
	pass

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * Global.travel_speed)
