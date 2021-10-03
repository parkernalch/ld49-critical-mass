extends Node2D
class_name Spawner

var neutron_scene = preload("res://Neutron.tscn")
var obstacle_scenes = [
	preload("res://ObstacleShort.tscn"),
	preload("res://ObstacleMedium.tscn"),
	preload("res://ObstacleLong.tscn")
]
onready var timer : Timer = $Timer
onready var obstacle_timer : Timer = $ObstacleTimer
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = randi()
	timer.wait_time = rng.randf_range(1, 3)
	obstacle_timer.wait_time = rng.randf_range(3.0, 9.0)
	timer.connect('timeout', self, '_on_timer_timeout')
	obstacle_timer.connect('timeout', self, '_on_obstacleTimer_timeout')
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	Events.connect("StartGame", self, "_on_StartGame")
	Events.connect("PlayerMovementSpeedChanged", self, "_on_player_movementSpeedChanged")

func _on_player_movementSpeedChanged(new_speed):
	timer.wait_time = rng.randf_range(1.0 / new_speed, 3.0 / new_speed)
	obstacle_timer.wait_time = rng.randf_range(3.0 / new_speed, 9.0 / new_speed)
	pass

func _on_StartGame():
	timer.wait_time = rng.randf_range(1.0 / Global.travel_speed, 3.0 / Global.travel_speed)
	obstacle_timer.wait_time = rng.randf_range(3.0 / Global.travel_speed, 9.0 / Global.travel_speed)
	timer.start()
	obstacle_timer.start()
	pass

func _process(delta):
	pass
	
func _on_ship_wasDestroyed():
	timer.stop()
	obstacle_timer.stop()
	pass
	
func _on_obstacleTimer_timeout():
	var obstacle = obstacle_scenes[rng.randi_range(0, 2)].instance()
	var offset = sin(randi())
	obstacle.transform.origin = transform.origin + (Vector2.RIGHT * offset * 40)
	obstacle.angular_velocity = rng.randf_range(-10.0, 10.0)
	get_parent().add_child(obstacle)
	pass
	
func _on_timer_timeout():
	timer.wait_time = rng.randf_range(1, 3) / Global.travel_speed
	spawn()
	pass
	
func spawn():
	var neutron = neutron_scene.instance()
	var offset = sin(randi())
	neutron.transform.origin = transform.origin + (Vector2.RIGHT * offset * 40)
	neutron.speed = 1.0
#	get_tree().get_root().add_child(neutron)
	get_parent().add_child(neutron)
	pass
