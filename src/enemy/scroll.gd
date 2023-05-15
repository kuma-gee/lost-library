extends Interactable

@export var spell_info_scene: PackedScene
@export var canvas: CanvasLayer
@export var portal_scene: PackedScene
@export var pickup_sound: AudioStreamPlayer

var open = false

func _on_interacted():
	if open: return
	
	open = true
	var info = spell_info_scene.instantiate()
	info.closed.connect(_on_close)
	canvas.add_child(info)

	pickup_sound.play()
	var spell = GameManager.next_random_unknown_spell()
	info.show_spell(spell)
	
func _on_close():
	var portal = portal_scene.instantiate()
	portal.global_position = global_position
	get_tree().current_scene.add_child(portal)
	
	hide()
	canvas.hide()
	pickup_sound.play()
	await pickup_sound.finished
	queue_free()
	
