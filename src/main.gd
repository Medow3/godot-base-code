extends Node2D

func _ready():
	SaveData.load_data(-1)
	#Music.play_song("Radiative")


func _on_play_pressed():
	Fade.fade_and_change_scene("res://src/ui/main_menu/profile_picking_menu/profile_picking_menu.tscn")


func _on_button_6_pressed():
	Fade.fade_and_change_scene("res://src/ui/main_menu/settings_menu/settings_menu.tscn")


func _on_controls_pressed():
	Fade.fade_and_change_scene("res://src/ui/main_menu/controls_menu/controls_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
