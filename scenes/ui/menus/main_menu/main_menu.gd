extends Node3D



func _on_start_button_pressed() -> void:
	MainScene.load_story_world()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
