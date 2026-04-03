class_name WeaponTier
extends Resource

@export var tier_dictionary : Dictionary[String, WeaponResource] = {}

func get_random_weapon() -> WeaponResource:
	return tier_dictionary.values().pick_random()
