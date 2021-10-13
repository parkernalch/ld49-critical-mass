extends Control

func _on_StatsPanel_visibility_changed():
	if visible:
		$Panel/CloseStatsButton.grab_focus()
