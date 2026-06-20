extends CharacterBody2D
class_name Car

const SPEED:int = 200


func _ready() -> void:
	velocity = Vector2(SPEED, 0)
	print("velocity", velocity)

func _process(_delta: float) -> void: 
	move_toward()

	
