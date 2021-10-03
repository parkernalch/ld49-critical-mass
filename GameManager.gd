extends Node2D

onready var stats_panel : Control = $StatsPanel
onready var game_over_screen : Control = $GameOverMenu
onready var game_over_label : Label = $GameOverMenu/Label
onready var retry_button : Button = $GameOverMenu/RetryButton
onready var stats_button : Button = $GameOverMenu/StatsButton
onready var start_button : Button = $GameOverMenu/StartButton

# statistics
onready var statistics = {
	"last_round": {
		"fuel_collected": {
			"reference": $StatsPanel/Panel/GridContainer/FuelCollectedLastRound,
			"value": 0
		},
		"distance_traveled": {
			"reference": $StatsPanel/Panel/GridContainer/DistanceTraveledLastRound,
			"value": 0
		} ,
		"rounds_played": {
			"reference": $StatsPanel/Panel/GridContainer/RoundsPlayedLastRound,
			"value": 0
		} ,
		"boost_time": {
			"reference": $StatsPanel/Panel/GridContainer/BoostTimeLastRound,
			"value": 0
		} 
	},
	"user_high": {
		"fuel_collected": {
			"reference": $StatsPanel/Panel/GridContainer/FuelCollectedUserHigh,
			"value": 0
		},
		"distance_traveled": {
			"reference": $StatsPanel/Panel/GridContainer/DistanceTraveledUserHigh,
			"value": 0
		} ,
		"rounds_played": {
			"reference": $StatsPanel/Panel/GridContainer/RoundsPlayedUserHigh,
			"value": 0
		} ,
		"boost_time": {
			"reference": $StatsPanel/Panel/GridContainer/BoostTimeUserHigh,
			"value": 0
		} 
	},
	"dev_high": {
		"fuel_collected": {
			"reference": $StatsPanel/Panel/GridContainer/FuelCollectedDevHigh,
			"value": 0
		},
		"distance_traveled": {
			"reference": $StatsPanel/Panel/GridContainer/DistanceTraveledDevHigh,
			"value": 0
		} ,
		"rounds_played": {
			"reference": $StatsPanel/Panel/GridContainer/RoundsPlayedDevHigh,
			"value": 0
		} ,
		"boost_time": {
			"reference": $StatsPanel/Panel/GridContainer/BoostTimeDevHigh,
			"value": 0
		} 
	},
}

func _ready():
	stats_panel.visible = false
	game_over_screen.visible = true
	retry_button.visible = false
	stats_button.visible = false
	game_over_label.visible = false
	Events.connect("GameEndedOdometer", self, "_on_odometer_gameEnded")
	Events.connect("GameEndedPlayer", self, "_on_player_gameEnded")

func _on_odometer_gameEnded(distance_traveled):
	statistics["last_round"]["distance_traveled"]["value"] = floor(distance_traveled)
	statistics["last_round"]["distance_traveled"]["reference"].text = str(floor(distance_traveled))
	if distance_traveled > statistics["user_high"]["distance_traveled"]["value"]:
		statistics["user_high"]["distance_traveled"]["value"] = floor(distance_traveled)
		statistics["user_high"]["distance_traveled"]["reference"].text = str(floor(distance_traveled))
		
func _on_player_gameEnded(stats):
	statistics["last_round"]["fuel_collected"]["value"] = stats["neutrons_collected"]
	statistics["last_round"]["fuel_collected"]["reference"].text = str(stats["neutrons_collected"])
	statistics["last_round"]["boost_time"]["value"] = stats["boost_time"]
	statistics["last_round"]["boost_time"]["reference"].text = str(stats["boost_time"])
	var rounds_played = statistics["user_high"]["rounds_played"]["value"] + 1
	statistics["last_round"]["rounds_played"]["value"] = rounds_played
	statistics["last_round"]["rounds_played"]["reference"].text = str(rounds_played)
	
	# process high scores
	if stats["neutrons_collected"] > statistics["user_high"]["fuel_collected"]["value"]:
		statistics["user_high"]["fuel_collected"]["value"] = stats["neutrons_collected"]
		statistics["user_high"]["fuel_collected"]["reference"].text = str(stats["neutrons_collected"])
	if stats["boost_time"] > statistics["user_high"]["boost_time"]["value"]:
		statistics["user_high"]["boost_time"]["value"] = stats["boost_time"]
		statistics["user_high"]["boost_time"]["reference"].text = str(stats["boost_time"])
	end_game()
	pass

func save():
	pass
	
func load():
	pass
	
func start_game():
	Events.emit_signal("StartGame")
	pass
	
func end_game():
	game_over_screen.visible = true
	start_button.visible = false
	retry_button.visible = true
	stats_button.visible = true
	stats_panel.visible = false
	
func toggle_stats():
	stats_panel.visible = not stats_panel.visible

func _on_RetryButton_pressed():
	start_game()

func _on_StartButton_pressed():
	start_game()

func _on_StatsButton_pressed():
	toggle_stats()

func _on_CloseStatsButton_pressed():
	toggle_stats()
