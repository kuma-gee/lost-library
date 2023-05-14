extends Interactable

@export var spell_info_scene: PackedScene
@export var canvas: CanvasLayer
@export var portal_scene: PackedScene

func _on_interacted():
	var info = spell_info_scene.instantiate()
	info.closed.connect(_on_close)
	canvas.add_child(info)
	
	var spell = GameManager.spells.pick_random()
	info.show_spell(spell)
	
func _on_close():
	var portal = portal_scene.instantiate()
	portal.global_position = global_position
	get_tree().current_scene.add_child(portal)
	queue_free()
