extends KinematicBody2D
class_name Player

var movement_vector : Vector2 = Vector2.ZERO
export var movement_speed : float = 1.0
var vertical_speed : float = 1.0
var boost_speed : float = 10.0
var fuel_level : int = 50
var ship_areas_are_healthy : Array = [ true, true, true ] # [left, body, right]

var is_collecting : bool = true
var is_boosting : bool = false

var neutrons_collected : int = 0
var boost_time : float = 0.0

onready var collection_area : Area2D = $CollectionArea
onready var damage_area : Area2D = $DamageArea
onready var sprite : Sprite = $Sprite
onready var fuel_timer : Timer = $FuelConsumptionTimer

func _ready():
	initialize()
	
func initialize():	
	collection_area.connect('body_entered', self, '_on_collisionArea_body_entered')
	damage_area.connect('body_entered', self, '_on_damageArea_body_entered')
	Events.connect("ShipWasDestroyed", self, '_on_ship_wasDestroyed')
	fuel_timer.wait_time = 0.5
	fuel_timer.connect('timeout', self, '_on_fuelTimer_timeout')
	call_deferred('deferred_emission')
	set_physics_process(false)
	set_process(false)
	Events.connect("StartGame", self, "_on_StartGame")
	
func _on_StartGame():
	ship_areas_are_healthy = [ true, true, true]
	movement_speed = 1.0
	vertical_speed = 1.0
	boost_speed = 10.0
	fuel_level = 50
	neutrons_collected = 0
	boost_time = 0.0
	initialize()
	set_physics_process(true)
	set_process(true)
	pass

func deferred_emission():
	Events.emit_signal("PlayerFuelLevelChanged", fuel_level)
	Events.emit_signal("PlayerMovementSpeedChanged", vertical_speed)	

func _process(delta):
	movement_vector = Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
		0
	) * movement_speed
	if movement_vector == Vector2.ZERO:
		sprite.frame = 0
	if movement_vector.x > 0:
		sprite.frame = 1
		sprite.flip_h = false
		if not ship_areas_are_healthy[2]:
			movement_vector *= 0.5
	if movement_vector.x < 0:
		sprite.frame = 1
		sprite.flip_h = true
		if not ship_areas_are_healthy[0]:
			movement_vector *= 0.5
	if Input.is_action_just_pressed("ui_fire"):
		if is_boosting:
			boost_end()
		else:
			boost_start()

func _physics_process(delta):
	move_and_collide(movement_vector)
	if is_boosting:
		boost_time += delta

func boost_start():
	print('starting boost!')
	fuel_timer.start()
	is_collecting = false
	is_boosting = true
	fuel_timer.wait_time = 1.0 / boost_speed
	Events.emit_signal("PlayerMovementSpeedChanged", boost_speed)

func boost_end():
	print('ending boost')
	fuel_timer.stop()
	is_collecting = true
	is_boosting = false
	Events.emit_signal("PlayerMovementSpeedChanged", vertical_speed)

func _on_fuelTimer_timeout():
	fuel_level -= 1
	if(fuel_level <= 0):
		Events.emit_signal("ShipWasDestroyed")
	Events.emit_signal("PlayerFuelLevelChanged", fuel_level)

func _on_ship_wasDestroyed():
	die()

func die():
	print('you lose!')
	Events.emit_signal("GameEndedPlayer", {
		"neutrons_collected": neutrons_collected,
		"boost_time": boost_time
	})
	queue_free()
	pass

func _on_collisionArea_body_entered(body):
	if body is Neutron:
		if is_collecting:
			body.collect(self)
			fuel_level += body.size
			neutrons_collected += 1
			Events.emit_signal("PlayerFuelLevelChanged", fuel_level)
			pass
		else:
			pass
	pass

func _on_damageArea_body_entered(body):
	if body is Neutron:
		body.queue_free()
	elif body is Obstacle:
		take_damage()
		Events.emit_signal("PlayerTookDamage", ship_areas_are_healthy)
		body.queue_free()
	pass

func take_damage():
	if movement_vector.x == 0:
		ship_areas_are_healthy[1] = false
	elif movement_vector.x < 0:
		ship_areas_are_healthy[0] = false
	else:
		ship_areas_are_healthy[2] = false
