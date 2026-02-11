extends Node2D

@export var rat_scene: PackedScene
@export var spawn_interval: float = 5.0
var spawn_time: float = 0.0

func _process(delta: float) -> void:
	spawn_time -= delta
	if spawn_time > 0.0:
		return
	spawn_time = spawn_interval
	
	var rat := rat_scene.instantiate()
	rat.global_position = position
	get_tree().current_scene.add_child(rat)
