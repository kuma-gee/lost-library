extends Interactable

@export var spells: Array[Resource]

func _on_interacted():
	queue_free()
