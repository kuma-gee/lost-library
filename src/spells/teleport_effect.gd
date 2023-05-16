extends AnimatedSprite2D

func _ready():
	play("default")
	animation_finished.connect(func(): queue_free())
