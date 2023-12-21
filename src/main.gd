extends Node2D


func _ready():
	Music.play_song("Radiative")


func _on_button_pressed():
	Fade.fade_and_change_scene("res://src/testing/scene1.tscn")


func _on_button_2_pressed():
	print(SaveData.create_new_profile(10))


func _on_button_3_pressed():
	print(SaveData.select_profile(10))


func _on_button_4_pressed():
	print(SaveData.get_global_saved_variable("test_variable"))


func _on_button_5_pressed():
	SaveData.set_global_saved_variable("test_variable", SaveData.get_global_saved_variable("test_variable") + 1)
	SaveData.save_data(SaveData.get_current_profile_number())
