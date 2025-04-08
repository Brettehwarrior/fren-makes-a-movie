extends Node3D

@export var bob_speed : float
@export var bob_intensity : float

var _noise : FastNoiseLite
var _initial_position : Vector3
var _initial_rotation : Vector3

var _current_time : float = 0


func _ready() -> void:
	_noise = FastNoiseLite.new()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_initial_position = position
	_initial_rotation = rotation


func _process(delta: float) -> void:
	if ReplayManager.is_playing_back():
		return
	
	_current_time += delta
	var offset = Vector2(_noise.get_noise_1d(_current_time * bob_speed + 3124321), _noise.get_noise_1d(_current_time * bob_speed + 120421)) * bob_intensity
	position = _initial_position + Vector3(offset.x, offset.y, 0)
	offset = Vector2(_noise.get_noise_1d(_current_time * bob_speed + 492832), _noise.get_noise_1d(_current_time * bob_speed + 6632112)) * bob_intensity
	rotation = _initial_rotation + Vector3(offset.x, offset.y, 0)

