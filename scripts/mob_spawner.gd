extends Node2D

@export var mob_scene: PackedScene

@export var spawn_interval := 1.0
@export var spawn_chance := 0.2
@export var max_mobs := 20

@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound
@onready var world: Node2D = $"../WorldBlocks"

var spawn_cells: Array[Vector2i] = []
var spawn_set := {} # Dictionary used as a set: cell -> true
var _acc := 0.0

func _ready() -> void:
	world.block_changed.connect(_on_block_changed)
	_rebuild_spawn_cells()

func _process(delta: float) -> void:
	_acc += delta
	if _acc < spawn_interval:
		return
	_acc = 0.0

	if randf() > spawn_chance:
		return

	if get_tree().get_nodes_in_group("mobs").size() >= max_mobs:
		return

	if spawn_cells.is_empty():
		return

	var cell := spawn_cells[randi() % spawn_cells.size()]
	_spawn_cell(cell)

	if spawn_sound:
		SoundManager.play_player(spawn_sound, world.cell_to_world(cell))

func _spawn_cell(air_cell: Vector2i) -> void:
	var mob := mob_scene.instantiate()
	mob.global_position = world.cell_to_world(air_cell)
	mob.add_to_group("mobs")
	get_tree().current_scene.add_child(mob)

func _on_block_changed(cell: Vector2i) -> void:
	# a change affects spawnability of:
	# - the tile itself (as ground)
	# - the tile below (its "above" might have changed)
	_update_cell_as_ground(cell)
	_update_cell_as_ground(cell + Vector2i(0, 1))

func _update_cell_as_ground(ground: Vector2i) -> void:
	var air := ground + Vector2i(0, -1)

	var is_ground = world.is_solid(ground)
	var is_air = world.is_air(air)
	var can_spawn = is_ground and is_air

	if can_spawn:
		_add_spawn_cell(air)
	else:
		_remove_spawn_cell(air)

func _add_spawn_cell(cell: Vector2i) -> void:
	if spawn_set.has(cell):
		return
	spawn_set[cell] = true
	spawn_cells.append(cell)

func _remove_spawn_cell(cell: Vector2i) -> void:
	if not spawn_set.has(cell):
		return
	spawn_set.erase(cell)
	var idx := spawn_cells.find(cell)
	if idx != -1:
		spawn_cells.remove_at(idx)

func _rebuild_spawn_cells() -> void:
	spawn_cells.clear()
	spawn_set.clear()
	for ground in world.get_used_cells():
		_update_cell_as_ground(ground)
