extends Node2D

onready var player : Player = $Player

func _ready():
	Events.connect("StartGame", self, "_on_StartGame")
	Events.connect("GameEndedPlayer", self, "_on_GameOver")
	pass
	
func _on_StartGame():
	start_game()
	
func _on_GameOver(any):
	end_game()
	
func start_game():
	pass

func end_game():
	pass
