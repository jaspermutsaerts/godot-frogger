extends CharacterBody2D
class_name Frog

const MOVE_SPEED = 100

signal died

var is_on_platform:bool = false
var platform:Node2D
var platform_offset:int = 0

@onready var animation_player:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_up"):
        position.y -= MOVE_SPEED
        rotation = 0
        is_on_platform = false

    elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
        var direction = Input.get_axis("ui_left", "ui_right")
        position.x += MOVE_SPEED * direction
        rotation = PI  *.5 * direction

    if is_on_platform:
        if is_instance_valid(platform):
            global_position.x = platform_offset + platform.global_position.x
        else:
            print("die")

func _on_screen_exited() -> void:
    emit_signal("died")


func hit_platform(obstacle:MovingObstacle) -> void:
    if is_on_platform:
        return

    is_on_platform = true
    platform = obstacle
    platform_offset = global_position.x - obstacle.global_position.x

func hit_obstacle(_obstacle:MovingObstacle) -> void:
    animation_player.play("splat")
    emit_signal("died")




func left_platform(obstacle:MovingObstacle) -> void:
    if not is_on_platform or not obstacle == platform:
        return

    is_on_platform = false
    platform = null
    platform_offset = 0
