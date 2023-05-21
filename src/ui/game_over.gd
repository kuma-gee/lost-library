extends Control

@export var menu_scene: PackedScene


func _on_menu_pressed():
	GameManager.reset()
	SceneManager.change_scene(menu_scene)


func _on_retry_pressed():
	GameManager.reset()
	SceneManager.reload_scene()
