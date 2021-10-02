extends Node2D
class_name Spawner

var neutron_scene = preload("res://Neutron.tscn")
onready var timer : Timer = $Timer
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = randi()
	timer.wait_time = rng.randi_range(1, 3)
	timer.start()
	timer.connect('timeout', self, '_on_timer_timeout')

func _process(delta):
	pass
	
func _on_timer_timeout():
	timer.wait_time = rng.randi_range(1, 3)
	spawn()
	pass
	
func spawn():
	var neutron = neutron_scene.instance()
	neutron.transform.origin = transform.origin
	neutron.speed = rng.randf_range(1.0, 3.0)
	get_tree().get_root().add_child(neutron)
	pass
