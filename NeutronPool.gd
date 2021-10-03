extends Node2D
class_name NeutronPool

var amount_to_pool : int = 2
var neutrons : Array = []
var index : int = 0

var neutron_scene = preload("res://Neutron.tscn")
onready var parent_scene = get_tree().get_root()

func _ready():
	add_to_group('pool')
	spawn_neutrons()

func spawn_neutrons():
	for i in range(amount_to_pool):
		var neutron = neutron_scene.instance()
		parent_scene.add_child(neutron)
#		neutron.deactivate()
		neutrons.push_back(neutron)
	pass

func get_neutron():
	index += 1
	if index > neutrons.size() - 1:
		index = 0
	return neutrons[index]
