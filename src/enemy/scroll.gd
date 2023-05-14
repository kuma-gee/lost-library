extends Interactable

@export var spell_info_scene: PackedScene
@export var canvas: CanvasLayer

func _on_interacted():
	var info = spell_info_scene.instantiate()
	info.closed.connect(func(): queue_free())
	canvas.add_child(info)
	
	var spell = GameManager.spells.pick_random()
	info.show_spell(spell)
