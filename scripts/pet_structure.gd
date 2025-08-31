enum {
	EARS_POINTY = 1,
	EARS_ROUND,
	EARS_ROUND_LONG,
	
	NOSE_BIG_ROUND,
	NOSE_SMALL_FLAT,
	NOSE_BIG_FLAT,
	
	HAIR_SPOTS_BIG,
	HAIR_SPOTS_SMALL,
	HAIR_SPOTS_HEARTS,
	
	HAIR_SPOTS_COLOR_BLOND,
	HAIR_SPOTS_COLOR_WHITE,
	HAIR_SPOTS_COLOR_BROWN,
	HAIR_SPOTS_COLOR_BLACK,
	HAIR_SPOTS_COLOR_GREY,
	
	HAIR_COLOR_BLOND,
	HAIR_COLOR_WHITE,
	HAIR_COLOR_GREY,
	HAIR_COLOR_BROWN,
	HAIR_COLOR_BLACK,
	
	NOSE_SMALL,
	NOSE_ROUND,
	NOSE_NARROW,
	NOSE_TALL,
	
	EYES_SMALL,
	EYES_CLOSED,
	EYES_COMMON,
	EYES_EYEPATCH
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
		EARS_ROUND: return "Droopy and small"
		EARS_ROUND_LONG: return "Droopy and big"
		
		NOSE_BIG_ROUND: return "Round and big"
		NOSE_ROUND: return "Round"
		NOSE_SMALL_FLAT: return "Small and flat"
		NOSE_BIG_FLAT: return "Big and flat"
		NOSE_NARROW: return "Narrow"
		
		HAIR_SPOTS_BIG: return "Big"
		HAIR_SPOTS_SMALL: return "Small"
		HAIR_SPOTS_HEARTS: return "Heart-shaped"
		
		HAIR_SPOTS_COLOR_BLACK, HAIR_COLOR_BLACK: return "Black"
		HAIR_SPOTS_COLOR_BLOND, HAIR_COLOR_BLOND: return "Blond"
		HAIR_SPOTS_COLOR_BROWN, HAIR_COLOR_BROWN: return "Brown"
		HAIR_SPOTS_COLOR_WHITE, HAIR_COLOR_WHITE: return "White"
		HAIR_SPOTS_COLOR_GREY, HAIR_COLOR_GREY: return "Grey"

		EYES_COMMON: return "Common"
		EYES_EYEPATCH: return "Eyepatch"
	
	return "Unknown"
