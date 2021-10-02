extends Node

var travel_speed : float = 1.0

func _ready():
	Events.connect("PlayerMovementSpeedChanged", self, "_on_player_movementSpeedChanged")
	pass

func _on_player_movementSpeedChanged(new_speed):
	travel_speed = new_speed
	print('travel_speed' + str(travel_speed))
	pass
