extends Control

signal closed()

@export var name_label: Label
@export var input_container: Control

const tex_map = [
	preload("res://assets/UI_Up.png"),
	preload("res://assets/UI_Down.png"),
	preload("res://assets/UI_Left.png"),
	preload("res://assets/UI_Right.png")
]

func show_spell(spell: SpellResource):
	name_label.text = spell.name
	
	for i in spell.inputs:
		var tex = TextureRect.new()
		tex.texture = tex_map[i]
		input_container.add_child(tex)

func _on_close_pressed():
	closed.emit()
