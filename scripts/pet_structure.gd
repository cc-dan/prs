enum {
	EARS_POINTY,
	EARS_ROUND,
	
	NOSE_BIG_ROUND,
	NOSE_SMALL_FLAT,
	
	HAIR_SPOTS_BIG,
	HAIR_SPOTS_SMALL
}

const example := {
	id = "Filipa",
	ears = EARS_POINTY,
	nose = NOSE_BIG_ROUND,
	hair_spots = HAIR_SPOTS_BIG
}

static func describe(element: int) -> String:
	match element:
		EARS_POINTY: return "Pointy"
		EARS_ROUND: return "Round"
		
		NOSE_BIG_ROUND: return "Round and big"
		NOSE_SMALL_FLAT: return "Small and flat"
		
		HAIR_SPOTS_BIG: return "Big"
		HAIR_SPOTS_SMALL: return "Small"
	
	return "Unknown"
