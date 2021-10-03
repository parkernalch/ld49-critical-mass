extends Node

var travel_speed : float = 1.0

func _ready():
	Events.connect("PlayerMovementSpeedChanged", self, "_on_player_movementSpeedChanged")
	Events.connect("ShipWasDestroyed", self, "_on_player_wasDestroyed")
	Events.connect("StartGame", self, "_on_startGame")
	pass

func _on_startGame():
	travel_speed = 1.0
	pass

func _on_player_movementSpeedChanged(new_speed):
	travel_speed = new_speed
	pass

func _on_player_wasDestroyed():
	travel_speed = 0.0;
	pass
