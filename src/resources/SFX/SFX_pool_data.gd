class_name SFXPoolData extends Resource

## Wether or not the same sound effect can be played twice in a row.
@export var prevent_same_sound_twice_in_a_row: bool = true
## A list of all the posible sound effects that can be played with weights.
@export var SFX_pool: Array[SFXWeightedData]

var last_played_sfx_data: SingleSFXData = null
var _crng: CustomRandomGenerator = CustomRandomGenerator.new()


func get_random_sfx() -> SingleSFXData:
	var weighted_sfx_dict: Dictionary = {}
	for value in SFX_pool:
		weighted_sfx_dict[value.sfx_data] = value.weight
	if prevent_same_sound_twice_in_a_row:
		weighted_sfx_dict.erase(last_played_sfx_data)
	
	var random_sfx: SingleSFXData = _crng.get_random_weighted_value(weighted_sfx_dict)
	last_played_sfx_data = random_sfx
	return random_sfx
