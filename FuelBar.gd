extends Node2D

var fuel_level : float = 1.0
onready var fuel_fill : Sprite = $fuel_bar_fill

func _ready():
	Events.connect("PlayerFuelLevelChanged", self, "_on_player_fuelLevelChanged")
	
func _on_player_fuelLevelChanged(new_level):
	fuel_level = float(new_level) / 100.0
	print(fuel_fill.material)
	fuel_fill.material.set_shader_param('fill_amount', fuel_level)
	print(fuel_fill.material.get_shader_param('fill_amount'))
	pass
