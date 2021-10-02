extends Control

var speed_value : float = 1.0
onready var fill_bar : NinePatchRect = $speed_bar_fill
var max_size = 258

func _ready():
	Events.connect("PlayerMovementSpeedChanged", self, "_on_player_movementSpeedChanged")
	pass
	
func _on_player_movementSpeedChanged(new_speed):
	speed_value = new_speed
	fill_bar.rect_size = Vector2(fill_bar.rect_size.x, speed_value / 10.0 * max_size)
	pass
