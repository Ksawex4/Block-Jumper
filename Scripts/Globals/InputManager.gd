extends Node

var Paused = false
var AllPlayerControls = {
	"Fency": {"left": KEY_A, "right": KEY_D, "up": KEY_W, "down": KEY_S, "cam": KEY_1},
	"Toasty": {"left": KEY_J, "right": KEY_L, "up": KEY_I, "down": KEY_K, "cam": KEY_3},
	"PanLoduwka": {"left": KEY_F, "right": KEY_H, "up": KEY_T, "down": KEY_G, "cam": KEY_2}
}

func ChangePlayerKeybind(playerKey, keybind, newKey):
	var player = AllPlayerControls.get(playerKey)
	if player != null:
		player[keybind] = newKey

func _ready():
	SignalMan.connect("Continue", Callable(self, "_on_continue"))

func GetKeyAxis(negKey: int, posKey: int) -> float:
	var axis = 0.0
	if Input.is_key_pressed(negKey):
		axis -= 1.0
	if Input.is_key_pressed(posKey):
		axis += 1.0
	return axis

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and not get_tree().get_nodes_in_group("pauseMenu").is_empty():
		get_tree().paused = true
		SignalMan.emit_signal("Pause")

func _on_continue():
	get_tree().paused = false

func GetControls(player: String):
	if AllPlayerControls.has(player):
		return AllPlayerControls[player]
	else:
		return null

func ResetVariablesToDefault(resetControls=false) -> void:
	Paused = false
	if resetControls:
		AllPlayerControls = {
			"Fency": {"left": KEY_A, "right": KEY_D, "up": KEY_W, "down": KEY_S, "cam": KEY_1},
			"Toasty": {"left": KEY_J, "right": KEY_L, "up": KEY_I, "down": KEY_K, "cam": KEY_2},
			"PanLoduwka": {"left": KEY_F, "right": KEY_H, "up": KEY_T, "down": KEY_G, "cam": KEY_3}
		}
