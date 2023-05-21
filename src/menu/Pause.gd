extends Menu

@export var start_scene: PackedScene

@onready var pause := $Pause
@onready var options := $Options

@onready var back_button := $Pause/CenterContainer/VBoxContainer/Back

func _ready():
	clear_menu()
	back_button.visible = start_scene != null


func _handle_event(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		if not is_menu_visible():
			change_menu(pause)
			get_viewport().set_input_as_handled()
		elif is_in_sub_menu():
			super._handle_event(event)
		else:
			_on_resume_pressed()


func update_menu():
	super.update_menu()
	
	visible = menu_stack.size() > 0
	get_tree().paused = visible


func _on_Options_pressed():
	change_menu(options)


func _on_resume_pressed():
	clear_menu()


func _on_back_pressed():
	if start_scene:
		SceneManager.change_scene(start_scene)
