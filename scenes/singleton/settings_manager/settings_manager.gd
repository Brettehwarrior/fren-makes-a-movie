extends Node

signal changed_visibility(is_visible : bool)
signal mouse_sensitivity_changed(value : float)
signal controller_sensitivity_changed(value : float)

const CONFIG_FILE_PATH = "user://settings.cfg"

@export var debug_overlay : Control
var debug_enabled : bool = false

@export var menu_parent : Control
@export var master_volume_slider : Slider
@export var master_volume_percentage_label : Label

@export var microphone_option_button : OptionButton
var _microphone_devices : Array = []

@export var mouse_sensitivity_slider : Slider
@export var mouse_sensitivity_label : Label

@export var controller_sensitivity_slider : Slider
@export var controller_sensitivity_label : Label

var _config_file : ConfigFile

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		menu_parent.visible = not menu_parent.visible
		changed_visibility.emit(menu_parent.visible)
		
	if event.is_action_pressed("enable_debug"):
		debug_enabled = not debug_enabled
		debug_overlay.visible = debug_enabled


func _ready() -> void:
	debug_overlay.visible = false
	menu_parent.visible = false
	_load_microphone_devices()
	_load_or_make_config_file()


func _load_microphone_devices() -> void:
	_microphone_devices = AudioServer.get_input_device_list()
	
	for i in range(len(_microphone_devices)):
		var device = _microphone_devices[i]
		microphone_option_button.add_item(device)
		if device == AudioServer.input_device:
			microphone_option_button.select(i)


func _load_or_make_config_file() -> void:
	_config_file = ConfigFile.new()
	var err = _config_file.load(CONFIG_FILE_PATH)
	if err != OK:
		_save_default_settings()
	_apply_settings_from_file()


func _save_default_settings() -> void:
	menu_parent.visible = true
	_config_file.set_value("Audio", "master_volume", 1)
	_config_file.set_value("Audio", "microphone_device_index", 1)
	_config_file.set_value("Controls", "mouse_sensitvity", 1)
	_config_file.set_value("Controls", "controller_sensitivity", 1)
	_config_file.save(CONFIG_FILE_PATH)


func _save_current_settings() -> void:
	_config_file.set_value("Audio", "master_volume", master_volume_slider.value / 100)
	_config_file.set_value("Audio", "master_volume", microphone_option_button.selected)
	_config_file.set_value("Controls", "mouse_sensitvity", mouse_sensitivity_slider.value)
	_config_file.set_value("Controls", "controller_sensitivity", controller_sensitivity_slider.value)
	_config_file.save(CONFIG_FILE_PATH)


func _apply_settings_from_file() -> void:
	master_volume_slider.value = _config_file.get_value("Audio", "master_volume", 1.0) * 100
	microphone_option_button.selected = _config_file.get_value("Audio", "master_volume", 0)
	AudioServer.input_device = _microphone_devices[microphone_option_button.selected]
	mouse_sensitivity_slider.value = _config_file.get_value("Controls", "mouse_sensitvity", 1.0)
	controller_sensitivity_slider.value = _config_file.get_value("Controls", "controller_sensitivity", 1.0)


func _on_load_default_settings_button_pressed() -> void:
	_save_default_settings()
	_apply_settings_from_file()


func _on_save_settings_button_pressed() -> void:
	_save_current_settings()


func _on_master_volume_slider_value_changed(value:float) -> void:
	master_volume_percentage_label.text = str(value) + "%"
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value/100)


func _on_mouse_sensitivity_slider_value_changed(value:float) -> void:
	mouse_sensitivity_changed.emit(value)
	mouse_sensitivity_label.text = "x" + str(value)


func _on_controller_sensitivity_slider_value_changed(value: float) -> void:
	controller_sensitivity_changed.emit(value)
	controller_sensitivity_label.text = "x" + str(value)


func _on_microphone_option_button_item_selected(index: int) -> void:
	AudioServer.input_device = _microphone_devices[index]

func is_showing():
	return menu_parent.visible


func _on_close_button_pressed() -> void:
	menu_parent.visible = false
	changed_visibility.emit(menu_parent.visible)
