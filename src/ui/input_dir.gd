class_name InputDirTexture
extends TextureRect

const spell_dir_map = {
	"move_up": preload("res://assets/UI_Up.png"),
	"move_down": preload("res://assets/UI_Down.png"),
	"move_left": preload("res://assets/UI_Left.png"),
	"move_right": preload("res://assets/UI_Right.png")
}

var input: String


func _ready():
	texture = spell_dir_map[input]
