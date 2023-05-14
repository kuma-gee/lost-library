extends Interactable

@export var activate_sound: AudioStreamPlayer

func _on_interacted():
	activate_sound.play()
	SceneManager.reload_scene()
