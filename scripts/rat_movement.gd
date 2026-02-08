extends CharacterBody2D

@export var speed := 15.0
@export var turn_cooldown := 0.15

var dir := -1
var turn_timer := 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_check: RayCast2D = $FloorCheck

func _ready() -> void:
	_update_floor_check()
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	turn_timer = max(turn_timer - delta, 0.0)

	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = dir * speed
	move_and_slide()

	# turn around on wall / ledge (with cooldown)
	if turn_timer <= 0.0:
		if is_on_wall():
			turn_around()
		elif is_on_floor() and not floor_check.is_colliding():
			turn_around()

	# --- Animations ---
	var anim := "idle"
	if abs(dir * speed) > 0.0:
		anim = "walk"

	if sprite.animation != anim:
		sprite.play(anim)

func turn_around() -> void:
	dir *= -1
	_update_floor_check()
	sprite.flip_h = dir < 0
	turn_timer = turn_cooldown

func _update_floor_check() -> void:
	floor_check.target_position.x = abs(floor_check.target_position.x) * dir
	floor_check.force_raycast_update()
