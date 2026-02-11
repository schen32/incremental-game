extends Node2D

@export var speed := 15.0
@export var turn_cooldown := 0.15

# Random behavior tuning
@export var idle_time_range := Vector2(0.8, 2.2)  # seconds
@export var walk_time_range := Vector2(1.2, 4.0)  # seconds

enum State { IDLE, WALK }
var state: State = State.IDLE
var state_timer := 0.0

var dir := -1
var turn_timer := 0.0

@onready var body: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var floor_check: RayCast2D = $"../FloorCheck"
@onready var anim_controller: Node2D = $"../AnimationController"
@onready var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	_update_floor_check()
	_enter_idle()

func _physics_process(delta: float) -> void:
	turn_timer = max(turn_timer - delta, 0.0)

	# gravity
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

	# state timer
	state_timer -= delta
	if state_timer <= 0.0:
		if state == State.IDLE:
			_enter_walk()
		else:
			_enter_idle()

	# movement
	if state == State.WALK:
		body.velocity.x = dir * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0.0, speed)

	# turn around on wall/ledge only while walking
	if state == State.WALK and turn_timer <= 0.0:
		if body.is_on_wall():
			turn_around()
		elif body.is_on_floor() and not floor_check.is_colliding():
			turn_around()

	var flip_sprite = dir < 0
	if state == State.IDLE:
		anim_controller.play_anim(&"idle", flip_sprite)
	elif state == State.WALK:
		anim_controller.play_anim(&"walk", flip_sprite)

func _enter_idle() -> void:
	state = State.IDLE
	state_timer = rng.randf_range(idle_time_range.x, idle_time_range.y)

func _enter_walk() -> void:
	state = State.WALK
	state_timer = rng.randf_range(walk_time_range.x, walk_time_range.y)

	# optional: sometimes change direction when starting to walk
	if rng.randf() < 0.35:
		turn_around()

func turn_around() -> void:
	dir *= -1
	_update_floor_check()
	turn_timer = turn_cooldown

func _update_floor_check() -> void:
	floor_check.target_position.x = abs(floor_check.target_position.x) * dir
	floor_check.force_raycast_update()
