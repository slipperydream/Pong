extends Panel

signal num_players
signal open_settings

func _on_settings_pressed():
	emit_signal("open_settings")


func _on_one_player_button_pressed():
	emit_signal("num_players", 1)
	hide()

func _on_two_player_button_pressed():
	emit_signal("num_players", 2)
	hide()
