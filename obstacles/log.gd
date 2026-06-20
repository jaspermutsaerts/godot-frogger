extends CharacterBody2D
class_name Log

const SPEED:int = 100


func _ready() -> void:
	velocity = Vector2(SPEED, 0)

func _process(delta: float) -> void: 
	move_and_slide()

	
