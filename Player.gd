extends KinematicBody2D
class_name Player

var movement_vector : Vector2 = Vector2.ZERO
export var movement_speed : float = 1.0
var health : int = 20

var is_collecting : bool = false

onready var collection_area : Area2D = $CollectionArea
onready var damage_area : Area2D = $DamageArea

func _ready():
	collection_area.connect('body_entered', self, '_on_collisionArea_body_entered')
	damage_area.connect('body_entered', self, '_on_damageArea_body_entered')
	pass

func _process(delta):
	movement_vector = Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
		0
	) * movement_speed
	move_and_collide(movement_vector)
	
	if Input.is_action_just_pressed('ui_down'):
		is_collecting = true
	if Input.is_action_just_released('ui_down'):
		is_collecting = false
	
	if health <= 0:
		print('you lose!!')
		queue_free()

func _on_collisionArea_body_entered(body):
	if body is Neutron:
		if is_collecting:
			body.collect(self)
			pass
		else:
			pass
	pass

func _on_damageArea_body_entered(body):
	print(body)
	if body is Neutron:
		health -= 1
		body.queue_free()
	pass
