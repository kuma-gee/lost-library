extends Interactable

@export var spell_info_scene: PackedScene
@export var canvas: CanvasLayer
@export var portal_scene: PackedScene
@export var pickup_sound: AudioStreamPlayer
@export var anim: AnimationPlayer

var open = false

func _ready():
	anim.animation_finished.connect(_on_anim_finished)
	anim.play("spawn")

func _on_anim_finished(anim_name: String):
	if anim_name == "spawn":
		anim.play("idle")
	elif anim_name == "burn":
		_burned()

func _burned():
	var portal = portal_scene.instantiate()
	portal.global_position = global_position
	get_tree().current_scene.add_child(portal)
	queue_free()

func _unhandled_input(event):
	if open:
		if event.is_action_pressed("cancel") or event.is_action_pressed("interact"):
			_on_close()

func _on_interacted():
	if open:
		_on_close()
		return
	
	open = true
	var info = spell_info_scene.instantiate()
	info.closed.connect(_on_close)
	canvas.add_child(info)

	pickup_sound.play()
	var spell = GameManager.next_random_unknown_spell()
	info.show_spell(spell)
	
func _on_close():
	canvas.hide()
	pickup_sound.play()
	anim.play("burn")
