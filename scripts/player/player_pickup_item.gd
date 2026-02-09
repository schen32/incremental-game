extends Area2D

@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
@onready var inventory: Node2D = $"../Inventory"

func _ready() -> void:
	body_entered.connect(_on_pickup_area_body_entered)

func _on_pickup_area_body_entered(body: Node) -> void:
	if not body.is_in_group("item"):
		return
	
	inventory.add_item(body.item_id)
	play_pickup_sound()

	var sprite := body.get_node_or_null("Sprite2D")
	if sprite: sprite.visible = false

	var shape := body.get_node_or_null("CollisionShape2D")
	if shape: shape.set_deferred("disabled", true)

	body.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED) # optional extra safety
	body.queue_free() # simplest: just free immediately
		
func play_pickup_sound() -> void:
	pickup_sound.pitch_scale = randf_range(0.8, 1.2)
	pickup_sound.volume_db = -20 + randf_range(-2.0, 2.0)
	pickup_sound.play()
