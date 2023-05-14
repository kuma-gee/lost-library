extends Control

signal closed()

@export var name_label: Label
@export var input_container: Control

func show_spell(spell: SpellResource):
	name_label.text = spell.name
	
	for i in spell.get_inputs():
		var tex = InputDirTexture.new()
		tex.input = i
		input_container.add_child(tex)

func _on_close_pressed():
	closed.emit()
