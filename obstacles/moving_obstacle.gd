@abstract
class_name MovingObstacle
extends CharacterBody2D

@abstract func get_speed() -> int

func _ready() -> void:
	velocity = Vector2(get_speed(), 0).rotated(rotation)

func _process(_delta: float) -> void:
	move_and_slide()


func _on_screen_exited() -> void:
	print("deleted offscreen")
	queue_free()