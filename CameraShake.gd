extends Camera2D
# followed tutorial on https://kidscancode.org/godot_recipes/2d/screen_shake/

var falloff = 0.9
var offset_magnitude = Vector2(10, 5)
var roll_magnitude = 0.05
var original_position

var shake_strength = 0.0
onready var noise = OpenSimplexNoise.new()
var noise_pos = 0

func _ready():
	noise.seed = randi()
	noise.period = 2
	noise.octaves = 1
	original_position = global_position
	Events.connect("PlayerTookDamage", self, "_on_player_tookDamage")

func _on_player_tookDamage(array):
	add_shake(array.count(false) / 2.0)

func _process(delta):
	if shake_strength:
		shake_strength = max(shake_strength - falloff * delta, 0)
		shake()
	else:
		global_position = original_position
		
func shake():
	var amount = pow(shake_strength, 2)
	noise_pos += 1
	rotation = roll_magnitude * amount * noise.get_noise_2d(noise.seed, noise_pos)
	offset.x = offset_magnitude.x * amount * noise.get_noise_2d(noise.seed, noise_pos)
	offset.y = offset_magnitude.y * amount * noise.get_noise_2d(noise.seed, noise_pos)
	
func add_shake(amount):
	shake_strength = min(shake_strength + amount, 1.0)
	
