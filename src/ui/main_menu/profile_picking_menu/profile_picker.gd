class_name ProfilePicker extends Button

@export var profile_number: int = 0
@export var display_number_override: String = ""
@export var go_to_scene: String = ""


func _ready():
	_update_profile_picker()


func _update_profile_picker() -> void:
	text = str(profile_number)
	if display_number_override != "":
		text = display_number_override


func set_profile_number(value: int) -> void:
	profile_number = value
	_update_profile_picker()


func _on_pressed():
	SaveData.select_profile(profile_number)
	Fade.fade_and_change_scene(go_to_scene)
