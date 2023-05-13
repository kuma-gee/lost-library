extends Control

@export var menu_scene: PackedScene

func _ready():
	visibility_changed.connect(func(): get_tree().paused = visible)

func _exit_tree():
	get_tree().paused = false

func _on_menu_pressed():
	SceneManager.change_scene(menu_scene)


func _on_retry_pressed():
	SceneManager.reload_scene()
