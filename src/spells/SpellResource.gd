class_name SpellResource
extends Resource

enum InputKey {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum Action {
	THUNDERSTORM,
	FIREBALL,
	EARTHQUAKE,
	TELEPORT,
}

const key_map = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
]

@export var inputs: Array[InputKey]
@export var name: String
@export var action: Action

func get_inputs() -> Array[String]:
	var result: Array[String] = []
	for i in inputs:
		result.append(key_map[i])
	return result

func get_action() -> Action:
	return action
