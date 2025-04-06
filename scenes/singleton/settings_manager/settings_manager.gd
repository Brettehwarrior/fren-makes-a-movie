extends Node

signal changed_visibility(is_visible : bool)

const CONFIG_FILE_PATH = "user://settings.cfg"

@export var menu_parent : Control
@export var master_volume_slider : Slider
@export var master_volume_percentage_label : Label

var _config_file : ConfigFile


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		menu_parent.visible = not menu_parent.visible
		changed_visibility.emit(menu_parent.visible)


func _ready() -> void:
	menu_parent.visible = false
	master_volume_slider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")) * 100
	_load_or_make_config_file()


func _load_or_make_config_file() -> void:
	_config_file = ConfigFile.new()
	var err = _config_file.load(CONFIG_FILE_PATH)
	if err != OK:
		_save_default_settings()
	_apply_settings_from_file()


func _save_default_settings() -> void:
	_config_file.set_value("Audio", "master_volume", 1)
	_config_file.save(CONFIG_FILE_PATH)


func _save_current_settings() -> void:
	_config_file.set_value("Audio", "master_volume", master_volume_slider.value / 100)
	_config_file.save(CONFIG_FILE_PATH)


func _apply_settings_from_file() -> void:
	master_volume_slider.value = _config_file.get_value("Audio", "master_volume") * 100


func _on_load_default_settings_button_pressed() -> void:
	_save_default_settings()
	_apply_settings_from_file()


func _on_save_settings_button_pressed() -> void:
	_save_current_settings()

func _on_master_volume_slider_value_changed(value:float) -> void:
	master_volume_percentage_label.text = str(value) + "%"
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value/100)
