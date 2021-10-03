extends Control

var speed_value : float = 1.0
onready var fill_bar : Sprite = $speed_bar_shape

func _ready():
	Events.connect("PlayerMovementSpeedChanged", self, "_on_player_movementSpeedChanged")
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	pass
	
func _on_player_movementSpeedChanged(new_speed):
	speed_value = new_speed
	fill_bar.material.set_shader_param('fill_amount', speed_value / 10.0);
	pass

func _on_ship_wasDestroyed():
	speed_value = 0.0
	fill_bar.material.set_shader_param('fill_amount', 0.0)
