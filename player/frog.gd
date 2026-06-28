extends CharacterBody2D
class_name Frog

const MOVE_SPEED = 100

enum DieMethod {
    RunOver,
    Drown,
}

var die_animations:Dictionary =  {
    DieMethod.RunOver: "splat",
    DieMethod.Drown: "drown",
}

var is_on_platform:bool = false
var is_alive:bool = true
var platform:Node2D
var platform_offset:float = 0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var collision_shape:CollisionShape2D = %CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    var horizontal_move:float = 0
    if is_alive:
        if Input.is_action_just_pressed("ui_up"):
            position.y -= MOVE_SPEED
            rotation = 0
            is_on_platform = false
            EventBus.emit_signal("frog_moved")

        elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
            var direction = Input.get_axis("ui_left", "ui_right")
            horizontal_move = MOVE_SPEED * direction
            rotation = PI * .5 * direction
            EventBus.emit_signal("frog_moved")



    if is_on_platform:
        if is_instance_valid(platform):
            # move with platform
            platform_offset += horizontal_move
            global_position.x = platform_offset + platform.global_position.x
        else:
            _die(DieMethod.Drown)

    elif horizontal_move:
        position.x += horizontal_move

# only way to get dragged off screen is on a water platform
func _on_screen_exited() -> void:
    _die(DieMethod.Drown)


func hit_platform(obstacle:MovingObstacle) -> void:
    if is_on_platform:
        return

    is_on_platform = true
    platform = obstacle
    platform_offset = global_position.x - obstacle.global_position.x

func hit_obstacle(obstacle:MovingObstacle) -> void:
    _die(DieMethod.RunOver)
    collision_shape.set_disabled.call_deferred(true)


func _die(method: DieMethod) -> void:
    if not is_alive:
        return

    is_alive = false
    animation_player.play(die_animations[method])
    EventBus.emit_signal("frog_died", self, method)
    await get_tree().create_timer(2).timeout
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0, 1.5)
    await tween.finished
    queue_free()


func left_platform(obstacle:MovingObstacle) -> void:
    if not is_on_platform or not obstacle == platform:
        return

    print("Left platform")
    is_on_platform = false
    platform = null
    platform_offset = 0