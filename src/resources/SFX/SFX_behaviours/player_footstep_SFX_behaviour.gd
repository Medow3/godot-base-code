class_name PlayerFootstepSFXBehaviour extends SFXBehaviour

@export var default_footstep_sfx_data: SFXData = sfx_data
@export var walking_on_object: Node


func update_sfx_data() -> void:
	if is_instance_valid(walking_on_object):
		if "footstep_sfx_data" in walking_on_object and walking_on_object.footstep_sfx_data != null:
			sfx_data = walking_on_object.footstep_sound
		else:
			if default_footstep_sfx_data != null:
				sfx_data = default_footstep_sfx_data
