extends Control

#gets called when one presses the 'exit' button
func _on_exit_button_pressed() -> void:
	get_tree().quit()

#gets called when one presses the 'Settings' button
func _on_settings_button_pressed() -> void:
	if $SettingsContainer/SettingsMenu != null:
		$SettingsContainer/SettingsMenu.show()
