extends Node3D

@export var native_file_dialog : NativeFileDialog
@export var screen : Node3D

func select_movie() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	native_file_dialog.show()


func _on_file_selected(path: String) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	screen.load_movie(path)


func _on_interaction_triggered() -> void:
	select_movie()


func _on_native_file_dialog_canceled() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
