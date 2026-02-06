extends RigidBody2D

@export var item: StringName = &"grass"
@export var tile_size := Vector2i(16, 16)

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound

func _ready() -> void:
	pickup_area.body_entered.connect(_on_pickup_area_body_entered)

func apply_appearance(atlas_coords: Vector2i) -> void:
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2(atlas_coords) * Vector2(tile_size), Vector2(tile_size))

func pop() -> void:
	apply_impulse(Vector2(randf_range(-16, 16), randf_range(-42, -26)))
	
func _on_pickup_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		play_pickup_sound()
		
		sprite.visible = false
		collision_shape.disabled = true
		pickup_area.monitoring = false

		pickup_sound.finished.connect(queue_free)
		
func play_pickup_sound() -> void:
	pickup_sound.pitch_scale = randf_range(0.8, 1.2)
	pickup_sound.volume_db = -10 + randf_range(-2.0, 2.0)
	pickup_sound.play()
