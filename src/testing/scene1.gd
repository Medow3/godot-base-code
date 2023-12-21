extends Node2D


func _ready():
	print("scene1")
	print(SaveData.get_global_saved_variable("test_variable"))
	SaveData.set_global_saved_variable("test_variable", 2)
	SaveData.save_data(SaveData.get_current_profile_number())
	
func _on_button_pressed():
	Fade.fade_and_change_scene("res://src/testing/scene2.tscn")


func _on_button_2_pressed():
	Fade.fade_out_call_func_fade_in()


func _on_button_3_pressed():
		get_tree().change_scene_to_file("res://src/testing/scene2.tscn")
