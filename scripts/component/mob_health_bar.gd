extends Node2D

@onready var health: Node2D = $"../Health"
@onready var bar: ProgressBar = $ProgressBar

func _ready() -> void:
	health.changed.connect(_on_health_changed)
	_on_health_changed(health.current_health, health.max_health)

func _on_health_changed(cur: int, maxv: int) -> void:
	bar.max_value = maxv
	bar.value = cur
