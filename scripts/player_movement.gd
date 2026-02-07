extends CharacterBody2D

@export var speed := 150.0
@export var jump_velocity := -250.0

# Feel settings (Celeste-ish)
@export var coyote_time := 0.12
@export var jump_buffer := 0.12
@export var fall_gravity_mult := 1.7      # faster fall
@export var low_jump_gravity_mult := 1.6  # tap jump = shorter
@export var max_fall_speed := 900.0

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

@onready var m_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var g := get_gravity()

	# --- timers ---
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("move_up"):
		jump_buffer_timer = jump_buffer
	else:
		jump_buffer_timer -= delta

	# --- gravity (floaty control) ---
	if not is_on_floor():
		# falling: stronger gravity
		if velocity.y > 0:
			velocity += g * fall_gravity_mult * delta
		# rising but jump released: stronger gravity (cuts jump short)
		elif not Input.is_action_pressed("move_up"):
			velocity += g * low_jump_gravity_mult * delta
		else:
			velocity += g * delta

		# cap fall speed
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	# --- jump (buffer + coyote) ---
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# --- horizontal movement ---
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# --- animations ---
	var anim := "idle"
	if not is_on_floor():
		anim = "jump"
	elif abs(velocity.x) > 1.0:
		anim = "walk"

	if m_sprite.animation != anim:
		m_sprite.play(anim)

	if direction != 0:
		m_sprite.flip_h = direction < 0

	move_and_slide()
