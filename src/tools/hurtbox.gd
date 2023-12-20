class_name Hurtbox extends Area2D

@onready var box_owner = get_parent()
@onready var collider = $hurtboc_collision

func _ready() -> void:
	assert(box_owner.has_method("take_damage"), "Hitbox owner does not have a take_damage function.")

func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	if is_instance_valid(hitbox):
		box_owner.take_damage(hitbox.get_damage(), hitbox.box_owner)

func set_disabled_to(new: bool) -> void:
	collider.set_deferred("disabled", new)
