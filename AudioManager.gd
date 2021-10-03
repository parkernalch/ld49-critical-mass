extends Node

onready var explosion : AudioStreamPlayer = $Explosion
onready var hit : AudioStreamPlayer = $Hit
onready var power_up : AudioStreamPlayer = $PowerUp
onready var select : AudioStreamPlayer = $Select
onready var start : AudioStreamPlayer = $Start
onready var warning : AudioStreamPlayer = $Warning
onready var in_game : AudioStreamPlayer = $GameMusic

var klaxxon_is_active : bool = false
onready var klaxxon_timer : Timer = $KlaxxonTimer

func _ready():
	Events.connect("PlayerTookDamage", self, "_on_player_tookDamage")
	Events.connect("ShipWasDestroyed", self, "play_sound", ['explosion'])
	Events.connect("StartGame", self, "play_sound", ['start'])
	Events.connect("PlayerFuelLevelChanged", self, "_on_player_fuelLevelChanged")
	klaxxon_timer.wait_time = 1.0
	klaxxon_timer.connect('timeout', self, "play_sound", ['warning'])
	pass

func play_sound(sound_name):
	match sound_name:
		'explosion':
			explosion.play()
			in_game.stop()
		'hit':
			hit.play()
		'power_up':
			power_up.play()
		'select':
			select.play()
		'start':
			start.play()
			in_game.play()
		'warning':
			warning.play()

func _on_player_tookDamage(array):
	play_sound('hit')

func _on_player_fuelLevelChanged(new_level):
	if new_level > 80 and not klaxxon_is_active:
		start_klaxxon()
		klaxxon_is_active = true
	elif new_level < 80 and klaxxon_is_active:
		end_klaxxon()
		klaxxon_is_active = false
	pass

func start_klaxxon():
	if klaxxon_is_active:
		return
	klaxxon_timer.start()
	pass
	
func end_klaxxon():
	if not klaxxon_is_active:
		return
	klaxxon_timer.stop()
	warning.stop()
	pass
