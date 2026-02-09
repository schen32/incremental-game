extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = get_parent()

func _ready() -> void:
	hitbox.monitoring = false
	sprite.visible = false
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	anim.animation_finished.connect(_on_animation_finished)

func _process(_delta):
	var dir := (get_global_mouse_position() - player.global_position).normalized()
	if dir.x < 0:
		scale.x = -1
	else:
		scale.x = 1

func attack() -> void:
	if anim.is_playing():
		return
	hitbox.monitoring = true
	sprite.visible = true
	anim.play("attack")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		hitbox.monitoring = false
		sprite.visible = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("hit mob")
