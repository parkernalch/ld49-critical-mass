extends Control
class_name GameOverMenu

export(NodePath) var stats_panel_path
onready var stats_panel = get_node(stats_panel_path)

func _ready():
	$StartButton.grab_focus()
	$ResumeButton.visible = false
	$RetryButton.visible = false
	$StatsButton.visible = false
	$Label.text = "CRITICAL MASS"
	$Label.visible = true
	Events.connect("StartGame", self, "start_game")
	Events.connect("GameEndedPlayer", self, "show_game_over")
	Events.connect("GamePaused", self, "show_pause")
	Events.connect("GameUnpaused", self, "start_game")

func start_game():
	print("showing start game")
	visible = false
	$StartButton.visible = false
	$RetryButton.visible = false
	$ResumeButton.visible = false
	$StatsButton.visible = false
	$Label.visible = false

func show_pause():
	print("showing pause")
	visible = true
	$ResumeButton.visible = true
	$StartButton.visible = false
	$StatsButton.visible = true
	$Label.text = "PAUSED"
	$Label.visible = true
	$ResumeButton.grab_focus()
	pass
	
func show_game_over(_obj):
	print("showing game over")
	visible = true
	$RetryButton.visible = true
	$StatsButton.visible = true
	$StartButton.visible = false
	$Label.text = "GAME OVER"
	$Label.visible = true
	$RetryButton.grab_focus()
	pass

func _on_StatsPanel_visibility_changed():
	print(stats_panel.visible)
	if not stats_panel.visible:
		if $StatsButton.visible:
			$StatsButton.grab_focus()
		elif $RetryButton.visible:
			$RetryButton.grab_focus()
		elif $ResumeButton.visible:
			$ResumeButton.grab_focus()
		elif $StartButton.visible:
			$StartButton.grab_focus()
