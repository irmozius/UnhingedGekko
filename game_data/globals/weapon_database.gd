extends Node

@export var weapon_db : Array[WeaponTier] = []

func get_weapon_from_dbname(wep_name : String) -> WeaponResource:
	for i : WeaponTier in weapon_db:
		if wep_name in i.tier_dictionary.keys():
			return i.tier_dictionary[wep_name]
	return null

func get_random_weapon_from_tier(tier : int) -> WeaponResource: 
	return weapon_db[tier].tier_dictionary.values().pick_random()

func get_random_weapon() -> WeaponResource:
	var randf : float = randf()
	if randf > 0.75:
		if randf > 95:
			return get_random_weapon_from_tier(2)
		return get_random_weapon_from_tier(1)
	return get_random_weapon_from_tier(0)
