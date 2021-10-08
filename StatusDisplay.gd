extends Node2D

onready var left_wing_sprite : Sprite = $ship_left_wing
onready var right_wing_sprite : Sprite = $ship_right_wing
onready var body_sprite : Sprite = $ship_body

func _ready():
	Events.connect("PlayerTookDamage", self, "_on_Player_tookDamage")
	Events.connect("PlayerHealed", self, "_on_Player_healed")
	
func set_status(sprite: Sprite, healthy: bool):
	if healthy:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 0, 0, 1)
	
func _on_Player_tookDamage(areas_are_healthy : Array):
	set_status(left_wing_sprite, areas_are_healthy[0])
	set_status(right_wing_sprite, areas_are_healthy[2])
	set_status(body_sprite, areas_are_healthy[1])
	if areas_are_healthy == [ false, false, false]:
		Events.emit_signal("ShipWasDestroyed")
	pass

func _on_Player_healed(areas_are_healthy : Array):
	set_status(left_wing_sprite, areas_are_healthy[0])
	set_status(right_wing_sprite, areas_are_healthy[2])
	set_status(body_sprite, areas_are_healthy[1])
	pass
