extends Control

func _on_start_pressed():
	SceneManager.change_scene("res://src/game.tscn")


func _on_exit_pressed():
	get_tree().quit()
