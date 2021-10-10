extends Node2D
class_name OptimizedNeutron

var composite_speed : float = 1.0
var size : int = 2
onready var sprite = $Sprite

var target
var player : Player;

var move_direction : Vector2

func _ready():
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	set_size(rand_range(1, 4))
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if not target:
		move_direction = Vector2.DOWN
	else:
		move_direction = (target.position - position).normalized() * 2.0
	
	position += move_direction * Global.travel_speed * delta * 60.0
	
	var dist_to_player = position.distance_squared_to(player.position)
	if dist_to_player < 1000.0:
		Events.emit_signal("PickedUpFuel", size)
		queue_free()	
	elif dist_to_player < player.collection_radius:
		target = player
	else:
		target = null

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
	set_physics_process(false)
	Events.connect("StartGame", self, "queue_free")
