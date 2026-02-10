extends Node2D

@export var weapon_data: WeaponData

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Sprite2D/Hitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../../"
@onready var hit_sound: AudioStreamPlayer2D = $HitSound

func _ready() -> void:
	hitbox.monitoring = false
	sprite.visible = false
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	anim.animation_finished.connect(_on_animation_finished)

func attack(data: WeaponData) -> void:
	if anim.is_playing():
		return
	weapon_data = data
	hitbox.monitoring = true
	sprite.visible = true
	anim.play("attack")
	
	var dir := (get_global_mouse_position() - player.global_position).normalized()
	if dir.x < 0:
		scale.x = -1
	else:
		scale.x = 1

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		hitbox.monitoring = false
		sprite.visible = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if weapon_data == null:
		return
	if not area.has_method("apply_damage"):
		return
	area.apply_damage(weapon_data.damage)

	if not area.has_method("apply_knockback"):
		return
	area.apply_knockback(player.global_position, weapon_data.knockback_force, weapon_data.knockback_duration)
	
	hit_sound.play()
