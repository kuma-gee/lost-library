class_name RemapButton
extends UIButton

@export var disable = false
@export var action := ""

var input := PlayerInput.new()

func _ready():
	super._ready()
	
	disabled = disable
	_update()

func _update():
	var ev = get_input()
	var type = InputType.to_type(ev)
	text = InputType.to_text(type)

func get_input() -> InputEvent:
	var inputs = InputMap.action_get_events(action)
	for i in inputs:
		if input.is_player_event(i):
			return i
	return null


func remap_input(ev: InputEvent) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, ev)
	_update()
