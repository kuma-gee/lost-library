class_name LabelHover
extends Label

@export var toggle_visibility = false
@export var control: Control
@export var highlight_color = Color.WHITE

func _ready():
	control.mouse_entered.connect(hover)
	control.mouse_exited.connect(unhover)
	unhover()

func hover():
	add_theme_color_override("font_color", highlight_color)
	if toggle_visibility:
		show()

func unhover():
	remove_theme_color_override("font_color")
	if toggle_visibility:
		hide()
