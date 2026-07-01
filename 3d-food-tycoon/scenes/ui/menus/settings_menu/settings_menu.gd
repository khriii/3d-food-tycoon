extends PanelContainer


func _ready() -> void:
	SettingsManager.load_settings_from_file() #do this when you want to load settings
	populate_settings()

#initializing button/sliders values based on settings
func populate_settings()->void:
	%FullscreenCheckbox.button_pressed=SettingsManager.is_fullscreen
	%MasterVolumeSlider.value=SettingsManager.master_volume_level
	%MusicVolumeSlider.value=SettingsManager.music_volume_level
	%SoundEffectsVolumeSlider.value=SettingsManager.sound_effects_volume_level
	var availableResolutions=SettingsManager.get_compatible_resolutions()
	for i in range(availableResolutions.size()):
		var label = str(availableResolutions[i].x) + "x" + str(availableResolutions[i].y)
		%ResOptionButton.add_item(label, i)
		%ResOptionButton.set_item_metadata(i,availableResolutions[i])

#--------
#SIGNALS
#--------
func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	SettingsManager.is_fullscreen=toggled_on

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.master_volume_level=value

func _on_music_volume_slider_value_changed(value: float) -> void:
	SettingsManager.music_volume_level=value

func _on_sound_effects_volume_slider_value_changed(value: float) -> void:
	SettingsManager.sound_effects_volume_level=value

func _on_close_button_pressed() -> void:
	SettingsManager.save_settings_to_file() #do this every now and then or when exiting the game
	hide()

#sets screen resolution. Triggered by changing the resolution option in settings
func _on_res_option_button_item_selected(index: int) -> void:
	var selectedRes:Vector2i=%ResOptionButton.get_item_metadata(index)
	DisplayServer.window_set_size(selectedRes)
