extends Node2D

export(bool) var is_active = false

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	Events.connect("PlayerShieldToggled", self, "_on_player_shieldToggled")
	$Sprite.visible = false
	$Timer.connect("timeout", self, "deactivate")
	set_physics_process(false)
	pass

func _on_body_entered(body):
	if body is Obstacle:
		if is_active:
			body.queue_free()
	pass

func _on_player_shieldToggled(value):
	if value:
		activate()
	else:
		deactivate()

func activate():
	$Sprite.material.set_shader_param("line_spacing", 0.10)
	$Sprite.material.set_shader_param("time_scaling", 0.5)
	$Sprite.visible = true
	$Timer.start()
	set_physics_process(true)
	is_active = true
	
func deactivate():
	$Sprite.material.set_shader_param("line_spacing", 0.0)
	$Sprite.material.set_shader_param("time_scaling", 0.0)
	$Sprite.visible = false
	set_physics_process(false)
	is_active = false
