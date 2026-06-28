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
var is_on_water:bool = false

var is_alive:bool = true
var platform:Node2D
var platform_offset:float = 0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var collision_shape:CollisionShape2D = %CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2(0, 0)

func setup(river_zone:Area2D) -> void:
   river_zone.connect("body_entered", _on_enter_river)
   river_zone.connect("body_exited", _on_exit_river)



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

    elif horizontal_move:
        position.x += horizontal_move

    # we fell in the water
    if is_alive and is_on_water and not is_on_platform:
        _die(DieMethod.Drown)

# only way to get dragged off screen is on a water platform
func _on_screen_exited() -> void:
    _die(DieMethod.Drown)


func entered_platform(obstacle:MovingObstacle) -> void:
    if platform == obstacle:
        return

    is_on_platform = true
    platform = obstacle
    platform_offset = global_position.x - obstacle.global_position.x

func hit_obstacle(obstacle:MovingObstacle) -> void:
    _die(DieMethod.RunOver)
    collision_shape.set_disabled.call_deferred(true)

func _on_enter_river(body:Node2D) -> void:
    if body != self:
        return

    is_on_water = true
    
func _on_exit_river(body:Node2D) -> void:
    if body != self:
        return

    is_on_water = false


func _die(method: DieMethod) -> void:
    if not is_alive:
        return

    is_alive = false

    rotation = 0 if method == DieMethod.Drown else rotation
    animation_player.play(die_animations[method])
    


func left_platform(obstacle:MovingObstacle) -> void:
    if not is_on_platform or not obstacle == platform:
        return

    is_on_platform = false
    platform = null
    platform_offset = 0
   
func _drown_animation_started() -> void:
    EventBus.emit_signal("frog_drown_started", self)

func _drown_animation_finished() -> void:
    EventBus.emit_signal("frog_drown_finished", self)
    
func _ran_over_animation_finished() -> void:
    EventBus.emit_signal("frog_ran_over", self)