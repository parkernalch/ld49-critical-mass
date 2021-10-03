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
			"value": 105
		},
		"distance_traveled": {
			"reference": $StatsPanel/Panel/GridContainer/DistanceTraveledDevHigh,
			"value": 15056
		} ,
		"rounds_played": {
			"reference": $StatsPanel/Panel/GridContainer/RoundsPlayedDevHigh,
			"value": "∞"
		} ,
		"boost_time": {
			"reference": $StatsPanel/Panel/GridContainer/BoostTimeDevHigh,
			"value": 15.9
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
	load_from_userdata()

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
	statistics["user_high"]["rounds_played"]["value"] = rounds_played
	statistics["user_high"]["rounds_played"]["reference"].text = str(rounds_played)
	
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
	var save_data = {
		"fuel_collected": {
			"last_round": statistics["last_round"]["fuel_collected"]["value"],
			"user_high": statistics["user_high"]["fuel_collected"]["value"]
		},
		"distance_traveled": {
			"last_round": statistics["last_round"]["distance_traveled"]["value"],
			"user_high": statistics["user_high"]["distance_traveled"]["value"]
		},
		"rounds_played": {
			"user_high": statistics["user_high"]["rounds_played"]["value"]
		},
		"boost_time": {
			"last_round": statistics["last_round"]["boost_time"]["value"],
			"user_high": statistics["user_high"]["boost_time"]["value"]
		}
	}
	var save_json = to_json(save_data)
	var save_file = File.new()
	save_file.open("user://game.save", File.WRITE)
	save_file.store_line(save_json)
	save_file.close()
	pass
	
func load_from_userdata():
	var save_file = File.new()
	if not save_file.file_exists("user://game.save"):
		return
	save_file.open("user://game.save", File.READ)
	var save_json = save_file.get_line()
	var save_data = parse_json(save_json)
	statistics["last_round"]["fuel_collected"]["value"] = save_data["fuel_collected"]["last_round"]
	statistics["last_round"]["distance_traveled"]["value"] = save_data["distance_traveled"]["last_round"]
	statistics["last_round"]["boost_time"]["value"] = save_data["boost_time"]["last_round"]
	statistics["user_high"]["rounds_played"]["value"] = save_data["rounds_played"]["user_high"]
	statistics["user_high"]["fuel_collected"]["value"] = save_data["fuel_collected"]["user_high"]
	statistics["user_high"]["distance_traveled"]["value"] = save_data["distance_traveled"]["user_high"]
	statistics["user_high"]["boost_time"]["value"] = save_data["boost_time"]["user_high"]
	save_file.close()
	write_statistics_to_panel()
	pass
	
func write_statistics_to_panel():
	for column in statistics.keys():
		if column == 'dev_high':
			continue
		for row in statistics[column].keys():
			statistics[column][row]["reference"].text = str(statistics[column][row]["value"])
	pass
	
func start_game():
	Events.emit_signal("StartGame")
	game_over_screen.visible = false
	pass
	
func end_game():
	game_over_screen.visible = true
	start_button.visible = false
	retry_button.visible = true
	stats_button.visible = true
	stats_panel.visible = false
	save()
	
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
