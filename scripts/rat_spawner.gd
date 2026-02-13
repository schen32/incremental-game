extends Node2D

@export var rat_scene: PackedScene
@export var spawn_interval: float = 5.0
var spawn_time: float = 0.0

@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound

func _process(delta: float) -> void:
	spawn_time -= delta
	if spawn_time > 0.0:
		return
	spawn_time = spawn_interval
	
	var rat := rat_scene.instantiate()
	rat.global_position = global_position
	get_tree().current_scene.add_child(rat)
	
	SoundManager.play_player(spawn_sound)
