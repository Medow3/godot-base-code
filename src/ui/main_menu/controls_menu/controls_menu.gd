extends Control

func _ready() -> void:
	$GridContainer/keybind_changer/Button.grab_focus()
	_update_keybind_changers()


func _on_back_pressed():
	Fade.fade_and_change_scene("res://src/main.tscn")


func _process(delta):
	if Input.is_action_just_pressed("test"):
		print("test")
	if Input.is_action_just_pressed("test2"):
		print("test2")


func _update_keybind_changers() -> void:
	for i: KeybindChanger in get_tree().get_nodes_in_group("Keybind Changer"):
		i.update_key_display()


func _on_reset_controls_to_default_pressed():
	Settings.keybinds.reset_keybinds_to_default()
	_update_keybind_changers()

