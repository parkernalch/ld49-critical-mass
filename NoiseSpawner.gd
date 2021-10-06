extends Node2D
class_name NoiseSpawner

export(Array, Resource) var object_scenes = []

#var neutron_scene = preload("res://Neutron.tscn")
#var obstacle_scenes = [
#	preload("res://ObstacleShort.tscn"),
#	preload("res://ObstacleMedium.tscn"),
#	preload("res://ObstacleLong.tscn")
#]

var noise = OpenSimplexNoise.new()
#var obstacle_noise = OpenSimplexNoise.new()

onready var left_bound : Node2D = $LeftBound
onready var right_bound : Node2D = $RightBound

var y_pos : float = 0.0
var y_speed : float = 0.0
export var subdivisions : int = 5

var last_spawn_value : float = 0.0
export var spawn_value : float = 1.0
export var spawn_cooldown : float = 1.0

var spawn_locations = []

func _ready():
	noise.seed = randi()
	noise.period = 1
	noise.octaves = 1
	Events.connect("PlayerMovementSpeedChanged", self, "_on_player_movementSpeedChanged")
	Events.connect("StartGame", self, "_on_startGame")
	Events.connect("GameEndedPlayer", self, "_on_endGame")
	var x_pos_left : float =  left_bound.transform.origin.x
	var x_pos_right : float = right_bound.transform.origin.x
	var x_dist : float = abs(x_pos_right - x_pos_left)
	var step_size = x_dist / float(subdivisions)

	for i in range(subdivisions):
		spawn_locations.append({
			"position": Vector2(x_pos_left + 3 * (step_size * i) / 2, transform.origin.y),
			"spawn_pos": 0.0			
		})
	print(spawn_locations)
	set_process(false)
		
func _process(delta):
	y_pos += Global.travel_speed * delta
	check_for_spawn()
	pass

func _on_endGame(_obj):
	set_process(false)

func _on_startGame():
	set_process(true)
	pass

func _on_player_movementSpeedChanged(new_speed):
	y_speed = new_speed

func check_for_spawn():
	for i in range(spawn_locations.size()):
		var pos = spawn_locations[i].position + Vector2.DOWN * y_pos
		var last_spawn = spawn_locations[i].spawn_pos
		var noise_value = noise.get_noise_2dv(pos)
		if noise_value >= spawn_value and y_pos > last_spawn + spawn_cooldown:
			spawn_locations[i].spawn_pos = y_pos
			spawn(spawn_locations[i].position)
	pass

func spawn(position):
	var choice = rand_range(0, object_scenes.size())
	var object = object_scenes[choice].instance()
	var offset = sin(randi())
	object.global_position = position + (Vector2.RIGHT * offset * 40)
#	object.speed = 1.0
	get_parent().add_child(object)