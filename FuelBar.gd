extends Node2D

var fuel_level : float = 1.0
onready var fuel_fill : Sprite = $fuel_bar_fill
onready var radioactive : Sprite = $icon_radioactive

func _ready():
	Events.connect("PlayerFuelLevelChanged", self, "_on_player_fuelLevelChanged")
	
func _on_player_fuelLevelChanged(new_level):
	fuel_level = float(new_level) / 100.0
	radioactive.material.set_shader_param('periodicity', clamp((fuel_level - 0.5) * 10.0, 0.0, 10.0))	
	fuel_fill.material.set_shader_param('fill_amount', fuel_level)
	pass
