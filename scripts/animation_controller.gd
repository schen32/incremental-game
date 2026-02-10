extends Node2D

signal anim_finished(name: StringName)
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var is_dead := false
var _current: StringName = &""

func _ready() -> void:
	sprite.animation_finished.connect(_on_sprite_anim_finished)

func play_anim(anim: StringName, flip_sprite: bool = false) -> void:
	if is_dead and anim != &"death":
		return

	_current = anim
	if anim == &"death":
		is_dead = true

	sprite.flip_h = flip_sprite
	sprite.play(anim) # play even if same anim, safer for death

func _on_sprite_anim_finished() -> void:
	emit_signal("anim_finished", _current)
