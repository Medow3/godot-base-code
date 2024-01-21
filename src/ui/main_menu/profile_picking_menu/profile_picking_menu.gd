class_name ProfilePickingMenu extends Control

@export var default_next_scene: String = ""

@onready var profiles_vbox = $VBoxContainer

func _ready():
	var index: int = 1
	for i: ProfilePicker in profiles_vbox.get_children():
		i.set_profile_number(index)
		i.go_to_scene = default_next_scene
		index += 1


