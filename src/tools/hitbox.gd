class_name Hitbox extends Area2D

@onready var box_owner = get_parent()
@onready var collider = $hitbox_collision

func _ready() -> void:
	assert(box_owner.get("damage"), "Hitbox owner does not have damage variable.")

func get_damage() -> float:
	return box_owner.damage
