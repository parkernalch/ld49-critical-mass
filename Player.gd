extends KinematicBody2D
class_name Player

var movement_vector : Vector2 = Vector2.ZERO
export var movement_speed : float = 1.0
var vertical_speed : float = 1.0
var fuel_level : int = 100
var ship_areas_are_healthy : Array = [ true, true, true ] # [left, body, right]

var is_collecting : bool = true

onready var collection_area : Area2D = $CollectionArea
onready var damage_area : Area2D = $DamageArea
onready var sprite : Sprite = $Sprite
onready var fuel_timer : Timer = $FuelConsumptionTimer

func _ready():
	collection_area.connect('body_entered', self, '_on_collisionArea_body_entered')
	damage_area.connect('body_entered', self, '_on_damageArea_body_entered')
	Events.connect("ShipWasDestroyed", self, '_on_ship_wasDestroyed')
	fuel_timer.wait_time = 0.5
	fuel_timer.start()
	fuel_timer.connect('timeout', self, '_on_fuelTimer_timeout')
	pass

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
	
#	if Input.is_action_just_pressed('ui_down'):
#		is_collecting = true
#	if Input.is_action_just_released('ui_down'):
#		is_collecting = false
		
	if Input.is_action_pressed('ui_up'):
		if vertical_speed < 9.9:
			vertical_speed += 0.1
			Events.emit_signal("PlayerMovementSpeedChanged", vertical_speed)
	if Input.is_action_pressed('ui_down'):
		if vertical_speed > 0.2:
			vertical_speed -= 0.1
			Events.emit_signal("PlayerMovementSpeedChanged", vertical_speed)
		
func _physics_process(delta):
	move_and_collide(movement_vector)

func _on_fuelTimer_timeout():
	fuel_level -= 1
	Events.emit_signal("PlayerFuelLevelChanged", fuel_level)

func _on_ship_wasDestroyed():
	# die animation
	queue_free()
	pass

func _on_collisionArea_body_entered(body):
	if body is Neutron:
		if is_collecting:
			body.collect(self)
			fuel_level += body.size
			Events.emit_signal("PlayerFuelLevelChanged", fuel_level)
			pass
		else:
			pass
	pass

func _on_damageArea_body_entered(body):
	print(body)
	if body is Neutron:
#		health -= 1
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
