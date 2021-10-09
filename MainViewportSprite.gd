extends Sprite

func _ready():
	Events.connect("PlayerBoostStarted", self, "_on_boost")
	pass
	
func _on_boost():
	$AnimationPlayer.play("BoostRipple")
	pass
