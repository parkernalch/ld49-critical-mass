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
var spawn_location : Vector2

var neutrons_collected : int = 0
var boost_time : float = 0.0

onready var collection_area : Area2D = $CollectionArea
onready var damage_area : Area2D = $DamageArea
onready var sprite : Sprite = $Sprite
onready var fuel_timer : Timer = $FuelConsumptionTimer
onready var right_wing_particles : CPUParticles2D = $damaged_right_wing
onready var left_wing_particles : CPUParticles2D = $damaged_left_wing
onready var body_particles : CPUParticles2D = $damaged_body
onready var explosion_particles : CPUParticles2D = $explosion

func _ready():
	spawn_location = transform.origin
	collection_area.connect('body_entered', self, '_on_collisionArea_body_entered')
	damage_area.connect('body_entered', self, '_on_damageArea_body_entered')
	Events.connect("ShipWasDestroyed", self, '_on_ship_wasDestroyed')
	Events.connect("StartGame", self, "_on_StartGame")
	fuel_timer.connect('timeout', self, '_on_fuelTimer_timeout')
	initialize()
	
func initialize():	
	fuel_timer.wait_time = 0.5
	is_collecting = true
	is_boosting = false
	call_deferred('deferred_emission')
	set_physics_process(false)
	set_process(false)
	transform.origin = spawn_location
	right_wing_particles.emitting = false
	left_wing_particles.emitting = false
	body_particles.emitting = false
	sprite.modulate = Color.white
	
func _on_StartGame():
	ship_areas_are_healthy = [ true, true, true]
	Events.emit_signal("PlayerTookDamage", ship_areas_are_healthy)
	movement_speed = 5.0
	vertical_speed = 2.0
	boost_speed = 10.0
	fuel_level = 50
	neutrons_collected = 0
	boost_time = 0.0
	initialize()
	set_physics_process(true)
	set_process(true)
	call_deferred("deferred_emission")
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
	fuel_timer.start()
	is_collecting = false
	is_boosting = true
	fuel_timer.wait_time = 1.0 / boost_speed
	Events.emit_signal("PlayerMovementSpeedChanged", boost_speed)

func boost_end():
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
	fuel_timer.stop()
	explosion_particles.emitting = true
	Events.emit_signal("GameEndedPlayer", {
		"neutrons_collected": neutrons_collected,
		"boost_time": boost_time
	})
	sprite.modulate = Color.black
	right_wing_particles.emitting = false
	left_wing_particles.emitting = false
	body_particles.emitting = false
	pass

func _on_collisionArea_body_entered(body):
	if body is Neutron:
		if is_collecting:
			body.collect(self)
			fuel_level += body.size
			vertical_speed += 0.1
			Events.emit_signal("PlayerMovementSpeedChanged", vertical_speed)
			neutrons_collected += 1
			Events.emit_signal("PlayerFuelLevelChanged", fuel_level)
			if fuel_level >= 100:
				boost_start()
			pass
		else:
			pass
	pass

func _on_damageArea_body_entered(body):
	if body is Neutron:
		body.queue_free()
	elif body is Obstacle:
		take_damage(body.transform.origin)
		Events.emit_signal("PlayerTookDamage", ship_areas_are_healthy)
		right_wing_particles.emitting = not ship_areas_are_healthy[2]
		body_particles.emitting = not ship_areas_are_healthy[1]
		left_wing_particles.emitting = not ship_areas_are_healthy[0]
		body.queue_free()
	pass

func take_damage(position):
	var offset = (transform.origin - position).x
	print('offset: ' + str(offset))
	if offset > 20:
		damage_ship('left', offset)
		ship_areas_are_healthy[0] = false
	elif offset < -20:
		damage_ship('right', offset)
		ship_areas_are_healthy[2] = false
	else:
		damage_ship('body', offset)
		ship_areas_are_healthy[1] = false
	boost_end()
	vertical_speed = 1.0
	Events.emit_signal("PlayerMovementSpeedChanged", vertical_speed)
	fuel_level = floor(fuel_level / (ship_areas_are_healthy.count(false) + 1))
	
func damage_ship(side, offset):
	if ship_areas_are_healthy.count(false) == 2:
		ship_areas_are_healthy = [ false, false, false]
		return
	match side:
		'left':
			for i in range(3):
				if ship_areas_are_healthy[i]:
					ship_areas_are_healthy[i] = false
					break
		'right':
			for i in range(3):
				if ship_areas_are_healthy[2-i]:
					ship_areas_are_healthy[2-i] = false
					break
		'body':
			if ship_areas_are_healthy[1]:
				ship_areas_are_healthy[1] = false
			else:
				if offset > 0.0:
					ship_areas_are_healthy[0] = false
				else:
					ship_areas_are_healthy[2] = false
