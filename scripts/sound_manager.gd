extends Node2D

@export var pool_size := 16
@export var default_pitch_variation := 0.2        # ±20% around base pitch
@export var default_volume_variation_db := 2.0    # ±2 dB around base volume
@export var max_distance := 0.0                   # 0 = don’t touch; otherwise set max_distance on players

var _pool: Array[AudioStreamPlayer2D] = []
var _next := 0

func _ready() -> void:
	_pool.resize(pool_size)
	for i in range(pool_size):
		var p := AudioStreamPlayer2D.new()
		p.name = "SFX_%02d" % i
		p.bus = "SFX"  # make sure you have an Audio Bus named SFX (or change this)
		add_child(p)
		_pool[i] = p


func play_stream(
	stream: AudioStream,
	play_position: Vector2,
	base_volume_db: float = 0.0,
	base_pitch: float = 1.0,
	pitch_variation: float = -1.0,
	volume_variation_db: float = -1.0
) -> void:
	if stream == null:
		return

	var p := _pool[_next]
	_next = (_next + 1) % _pool.size()

	# stop if still playing (pool reuse)
	if p.playing:
		p.stop()

	p.stream = stream
	p.global_position = play_position

	# defaults (per-call overrides)
	var pv := default_pitch_variation if pitch_variation < 0.0 else pitch_variation
	var vv := default_volume_variation_db if volume_variation_db < 0.0 else volume_variation_db

	# randomize around base values
	p.pitch_scale = base_pitch * randf_range(1.0 - pv, 1.0 + pv)
	p.volume_db = base_volume_db + randf_range(-vv, vv)

	if max_distance > 0.0:
		p.max_distance = max_distance

	p.play()


func play_player(
	player: AudioStreamPlayer2D,
	play_position: Vector2 = Vector2.ZERO,
	pitch_variation: float = -1.0,
	volume_variation_db: float = -1.0
) -> void:
	# Convenience: use an existing player’s settings (stream/bus/volume/pitch)
	if player == null or player.stream == null:
		return

	play_stream(
		player.stream,
		play_position,
		player.volume_db,
		player.pitch_scale,
		pitch_variation,
		volume_variation_db
	)
