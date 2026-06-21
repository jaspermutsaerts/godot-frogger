@abstract
class_name MovingObstacle
extends CharacterBody2D

var _speed:int = 0

func set_speed(speed: int) -> void:
	_speed = speed

func _ready() -> void:
	velocity = Vector2(_speed, 0).rotated(rotation)

func _process(_delta: float) -> void:
	move_and_slide()


func _on_screen_exited() -> void:
	print("deleted offscreen")
	queue_free()