extends Node3D



func _on_start_button_pressed() -> void:
	MainScene.load_story_world()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_git_hub_button_pressed() -> void:
	OS.shell_open("https://github.com/Brettehwarrior/fren-makes-a-movie")


func _on_discord_button_pressed() -> void:
	OS.shell_open("https://discord.gg/rjEwbFFguU")
