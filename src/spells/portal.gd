extends Interactable

@export var activate_sound: AudioStreamPlayer
@export var anim: AnimationPlayer

func _ready():
	anim.play("spawn")
	await anim.animation_finished
	anim.play("idle")

func _on_interacted():
	activate_sound.play()
	GameManager.next_level()


func interact():
	super.interact()
	return "portal"
