extends CanvasLayer

signal middle_of_fade

@onready var color_rect = $Control/ColorRect
@onready var tween = $Tween


func fade_and_change_scene(scene_path: String, fade_length: float = 0.3, fade_wait: float = 0.0):
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0), 
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	await tween.tween_completed
	if fade_wait > 0.0:
		await get_tree().create_timer(fade_wait).timeout
	var error = get_tree().change_scene_to_file(scene_path)
	assert(error == OK) #,"Failed to change to scene")
#	if is_instance_valid(GameManager.current_room_object):
#		GameManager.current_room_object.set_pause_room(false)
	SFX.stop_all_sfx()
#	yield(get_tree().create_timer(0.2), "timeout")
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0),
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()


func fade_and_reload_scene(fade_length: float = 0.3):
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0),
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	await tween.tween_completed
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()


func fade_out_in_signal(fade_length: float = 0.3) -> void:
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0),
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	await tween.tween_completed
	emit_signal("middle_of_fade")
	await get_tree().create_timer(0.2).timeout
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()


func fade_out_in(fade_length: float = 0.3):
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0),
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	await tween.tween_completed
	await get_tree().create_timer(0.2).timeout
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 
			fade_length, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()


func curtain_fade_signal() -> void:
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0),
			0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	await tween.tween_completed
	emit_signal("middle_of_fade")
	await get_tree().create_timer(0.2).timeout
	tween.interpolate_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 
			0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
