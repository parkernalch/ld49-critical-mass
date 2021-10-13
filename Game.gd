extends Node2D

onready var player : Player = $Player

func _ready():
	Events.connect("StartGame", self, "_on_StartGame")
	Events.connect("GameEndedPlayer", self, "_on_GameOver")
	Events.connect("PlayerFuelLevelChanged", self, "_on_player_fuelLevelChanged")
	Events.connect("GamePaused", self, "_on_GamePaused")
	Events.connect("GameUnpaused", self, "_on_GameUnpaused")
	pass
	
func _on_GamePaused():
	pass
	
func _on_GameUnpaused():
	pass
	
func _on_StartGame():
	start_game()
	
func _on_GameOver(any):
	call_deferred("end_game")
	
func start_game():
	$Player.visible = true
	pass

func end_game():
	$AnimationPlayer.stop()
	$play_field.material.set_shader_param("bar_color", $play_field.material.get_shader_param("screen_color"))
#	$Player.visible = false
	$Player.right_wing_particles.emitting = false
	$Player.left_wing_particles.emitting = false
	$Player.body_particles.emitting = false
	pass

func _on_player_fuelLevelChanged(new_level):
	if new_level < 25:
		$AnimationPlayer.play("PlayFieldLowWarning")
	elif new_level > 75:
		$AnimationPlayer.play("PlayFieldWarning")
	else:
		$AnimationPlayer.stop()
		$play_field.material.set_shader_param("bar_color", $play_field.material.get_shader_param("screen_color"))
	pass
