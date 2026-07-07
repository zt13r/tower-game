class_name Util


const PERCENT_TO_DECIMAL : float = 0.01


static func get_percent_damage(health: float, percent: float) -> float:
	return health * (percent * PERCENT_TO_DECIMAL)
