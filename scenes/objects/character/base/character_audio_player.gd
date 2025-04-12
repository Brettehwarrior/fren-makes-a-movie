extends Node3D

@export var character : ReplayableCharacter
@export var footstep_stream : AudioStream
@export var jump_stream : AudioStream

func _ready() -> void:
	character.jumped.connect(_on_character_jumped)


func _on_character_jumped() -> void:
	AudioManager.play_oneshot(jump_stream, global_position, 1)


func play_footstep_sound() -> void:
	if character.is_on_floor():
		AudioManager.play_oneshot(footstep_stream, global_position, -30)

