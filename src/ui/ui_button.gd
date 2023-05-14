extends Button

@export var hover_sound: AudioStreamPlayer
@export var click_sound: AudioStreamPlayer

func _ready():
	pressed.connect(_on_pressed)
	focus_entered.connect(_on_focus_hover)
	mouse_entered.connect(_on_focus_hover)
	
func _on_pressed():
	click_sound.play()

func _on_focus_hover():
	hover_sound.play()
