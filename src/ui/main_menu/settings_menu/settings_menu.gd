class_name SettingsMenu extends Control



func _on_reset_button_pressed():
	Settings.reset_settings_to_default()


func _on_back_button_pressed():
	Fade.fade_and_change_scene("res://src/main.tscn")
