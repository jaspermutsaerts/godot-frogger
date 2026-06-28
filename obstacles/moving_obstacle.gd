@abstract
class_name MovingObstacle
extends Area2D

var _speed:int = 0
var _velocity:Vector2
var _is_platform:bool = false

@export var is_platform:bool = false


func set_speed(speed: int) -> void:
    _speed = speed
    
func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

    _velocity = Vector2(_speed, 0)

func _process(delta: float) -> void:
    position += _velocity * delta

func _on_screen_exited() -> void:
    # print("deleted offscreen")
    queue_free()

func _on_body_entered(body:Node2D) -> void:
    if not body is Frog:
        return

    var frog:Frog = body

    if is_platform:
        print("frog entered platform")
        frog.entered_platform(self)
    else:
        frog.hit_obstacle(self)

func _on_body_exited(body:Node2D) -> void:
     if body is Frog:
        body.left_platform(self)
