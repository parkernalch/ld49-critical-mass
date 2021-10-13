extends Node2D
class_name Pickup

enum PICKUP {
	HEALTH,
	SHIELD,
	MAGNET
}

var value : int = 1
export(PICKUP) var type
var target
var player
var move_direction : Vector2

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	Events.connect("GameEndedPlayer", self, "_on_game_ended")
	Events.connect("GamePaused", self, "_on_GamePaused")
	Events.connect("GameUnpaused", self, "_on_GameUnpaused")
	pass

func _on_GamePaused():
	set_physics_process(false)
	
func _on_GameUnpaused():
	set_physics_process(true)

func _physics_process(delta):
	if position.y > 700.0:
		queue_free()
	if not target:
		move_direction = Vector2.DOWN
	else:
		move_direction = (target.position - position).normalized() * 2.0
	
	position += move_direction * Global.travel_speed * delta * 60.0
	
	var dist_to_player = position.distance_squared_to(player.position)
	if dist_to_player < 1000.0:
		Events.emit_signal("PickupAcquired", type, value)
		queue_free()	
	elif dist_to_player < player.collection_radius:
		target = player
	else:
		target = null
	pass
	
func _on_game_ended():
	set_physics_process(false)
