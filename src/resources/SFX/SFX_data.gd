class_name SFXData extends Resource

## The sfx to be played.
@export var single_sfx: SingleSFXData = null
## A pool of sfx which will get played randomly.
## This takes priority over the single_sfx.
@export var sfx_pool: SFXPoolData = null

func get_sfx() -> SingleSFXData:
	if sfx_pool != null:
		return sfx_pool.get_random_sfx()
	return single_sfx
