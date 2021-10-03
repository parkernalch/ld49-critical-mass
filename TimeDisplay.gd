extends Control

var traveled_distance : float = 0.0

onready var dist : Label = $dist_label

func _ready():
	traveled_distance = 0.0
	set_display()
	Events.connect("ShipWasDestroyed", self, "_on_ship_wasDestroyed")
	Events.connect("StartGame", self, "_on_StartGame")
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
