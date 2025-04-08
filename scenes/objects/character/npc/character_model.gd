class_name CharacterModel
extends Node3D

@export var replayable_character : ReplayableCharacter
@export var animation_player : AnimationPlayer


func _ready() -> void:
	replayable_character.started_walking.connect(_on_fren_started_walking)
	replayable_character.stopped_walking.connect(_on_fren_stopped_walking)
	animation_player.current_animation = "idle"


func _on_fren_started_walking() -> void:
	animation_player.current_animation = "hop"


func _on_fren_stopped_walking() -> void:
	animation_player.current_animation = "idle"

