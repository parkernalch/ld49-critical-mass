extends Node

onready var explosion : AudioStreamPlayer = $Explosion
onready var hit : AudioStreamPlayer = $Hit
onready var power_up : AudioStreamPlayer = $PowerUp
onready var select : AudioStreamPlayer = $Select
onready var start : AudioStreamPlayer = $Start
onready var warning : AudioStreamPlayer = $Warning
onready var in_game : AudioStreamPlayer = $GameMusic
onready var boost_start : AudioStreamPlayer = $Boost
onready var boost_end : AudioStreamPlayer = $BoostEnd

var klaxxon_is_active : bool = false
onready var klaxxon_timer : Timer = $KlaxxonTimer

func _ready():
	Events.connect("PlayerTookDamage", self, "_on_player_tookDamage")
	Events.connect("ShipWasDestroyed", self, "play_sound", ['explosion'])
	Events.connect("StartGame", self, "play_sound", ['start'])
	Events.connect("PlayerFuelLevelChanged", self, "_on_player_fuelLevelChanged")
	Events.connect("PlayerBoostStarted", self, "_on_player_boostStart")
	Events.connect("PlayerBoostEnded", self, "_on_player_boostEnd")
	klaxxon_timer.wait_time = 1.0
	klaxxon_timer.connect('timeout', self, "play_sound", ['warning'])

	explosion.volume_db = -20.0
	hit.volume_db = -20.0
	power_up.volume_db = -20.0
	select.volume_db = -20.0
	start.volume_db = -20.0
	warning.volume_db = -20.0
	in_game.volume_db = -20.0
	boost_start.volume_db = -20.0
	boost_end.volume_db = -20.0

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
		'boost_start':
			boost_start.play()
		'boost_end':
			boost_end.play()

func _on_player_boostStart():
	play_sound('boost_start')
	if in_game.playing:
		in_game.pitch_scale = 1.2
	pass

func _on_player_boostEnd():
	play_sound('boost_end')
	if in_game.playing:
		in_game.pitch_scale = 1.0
	pass

func _on_player_tookDamage(array):
	play_sound('hit')
	in_game.stop()
	if array.count(true) > 0:
		in_game.play()

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
