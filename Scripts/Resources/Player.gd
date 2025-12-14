extends Resource
class_name Player

enum StickType {
	NONE,
	NORMAL,
	CHEESE,
}
@export var Health: int
@export var Max_health: int
@export var WhoAmI: String
@export var X_speed: float
@export var Jump_height: float
@export var Gravity_difference: float = 0.0
@export var Stick: StickType
@export var Controls: Dictionary = {
	"Left": "FencyLeft",
	"Right": "FencyRight",
	"Jump": "FencyJump",
}
signal Died()
signal StatsChanged()
var Poison_damage_left := 0


func load_stats(data: Dictionary={}) -> void:
	if data:
		Health = data["Health"] if int(data["Health"]) else null
		Max_health = data["Max_health"] if int(data["Max_health"]) else null
		emit_signal("StatsChanged")
		match int(data["Stick"]):
			0: Stick = StickType.NONE
			1: Stick = StickType.NORMAL
			2: Stick = StickType.CHEESE
 

func get_save_data() -> Dictionary:
	return {
		"Health": Health,
		"Max_health": Max_health,
		"X_speed": X_speed,
		"Jump_height": Jump_height,
		"Stick": Stick,
	}


func hurt(damage: int) -> void:
	Health -= damage
	emit_signal("StatsChanged")
	PlayerStats.emit_signal("StatsChanged")
	if not is_alive():
		emit_signal("Died")


func heal(amount: int) -> void:
	Health += amount
	if Health > Max_health:
		Health = Max_health
	emit_signal("StatsChanged")
	PlayerStats.emit_signal("StatsChanged")


func is_alive() -> bool:
	return Health > 0


func has_stick() -> bool:
	return Stick != StickType.NONE
