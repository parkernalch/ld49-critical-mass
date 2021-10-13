extends Control

var traveled_distance : float = 0.0
var difficulty_levels = [
	1000,
	5000,
	15000,
	30000,
	70000,
	120000,
	280000,
	450000,
]

onready var dist : Label = $dist_label

func _ready():
	traveled_distance = 0.0
	set_display()
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	Events.connect("StartGame", self, "_on_StartGame")
	Events.connect("GamePaused", self, "_on_GamePaused")
	Events.connect("GameUnpaused", self, "_on_GameUnpaused")
	set_process(false)
	pass

func _on_GameUnpaused():
	set_process(true)
	pass
	
func _on_GamePaused():
	set_process(false)
	pass

func _on_StartGame():
	traveled_distance = 0.0
	set_process(true)
	pass

func _on_ship_wasDestroyed():
	Events.emit_signal("GameEndedOdometer", traveled_distance)
	pass

func _process(delta):
	traveled_distance += Global.travel_speed
	set_display()
	check_for_difficulty_increase()
	
func check_for_difficulty_increase():
	if traveled_distance > difficulty_levels[0]:
		Events.emit_signal("DifficultyIncreased")
		difficulty_levels.pop_front()
	
func set_display():
	var distance = floor(traveled_distance)
	
	var distance_text = str(distance)

	var prefix = ""
	match distance_text.length():
		0:
			prefix = "0000000"
		1:
			prefix = "000000"
		2:
			prefix = "00000"
		3:
			prefix = "0000"
		4:
			prefix = "000"
		5:
			prefix = "00"
		6:
			prefix = "0"
	distance_text = prefix + distance_text
	dist.text = distance_text
