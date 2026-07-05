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

var is_on_water:bool = false
var _death_layer:Node2D # Layer serves to change z-index more visually on death

var is_alive:bool = true
var on_platforms:Array[Node2D] = []
var platform_offset:float = 0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var collision_shape:CollisionShape2D = %CollisionShape2D
@onready var blood_particles_emitter:CPUParticles2D = $BloodParticlesEmitter
@onready var water_particles_emitter:CPUParticles2D = $WaterParticlesEmitter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2(0, 0)

func setup(river_zone:Area2D, end_zone_layer:Node2D, death_layer:Node2D) -> void:
    river_zone.connect("body_entered", _on_enter_river)
    river_zone.connect("body_exited", _on_exit_river)

    for end_zone:Area2D in end_zone_layer.get_children():
        end_zone.connect("body_entered", func(body: Node): _on_end_zone_reached(end_zone))

    _death_layer = death_layer

func is_on_platform() -> bool:
    return not on_platforms.is_empty()


func _process(_delta: float) -> void:
    velocity = Vector2(0, 0)

    var horizontal_move:float = 0
    if is_alive:
        if Input.is_action_just_pressed("ui_up"):
            position.y -= MOVE_SPEED
            rotation = 0
            animation_player.play("walk")

        elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
            var direction = Input.get_axis("ui_left", "ui_right")
            horizontal_move = MOVE_SPEED * direction
            rotation = PI * .5 * direction

    if is_on_platform():
        var platform:MovingObstacle = on_platforms[-1]
        velocity = platform._velocity
        move_and_slide()

    if horizontal_move:
        if is_x_on_screen(global_position.x + horizontal_move):
            position.x += horizontal_move
            animation_player.play("walk")


    # we fell in the water
    if is_alive and is_on_water and not is_on_platform():
        _die(DieMethod.Drown)

func _on_screen_exited() -> void:
    global_position.x = clamp_x_to_screen(global_position.x, 50)
    if is_on_water:
        _die(DieMethod.Drown)

func is_x_on_screen(global_x:float) -> bool:
    return global_x == clamp_x_to_screen(global_x)


func clamp_x_to_screen(global_x:float, offset:int = 0) -> float:
    var screen_width:float = get_viewport().size.x
    return clamp(global_x, offset, screen_width - offset)


func entered_platform(platform:MovingObstacle) -> void:
    if platform not in on_platforms:
        on_platforms.append(platform)

func left_platform(platform:MovingObstacle) -> void:
    on_platforms.erase(platform)


func hit_obstacle(obstacle:MovingObstacle) -> void:
    _die(DieMethod.RunOver)

func _on_enter_river(body:Node2D) -> void:
    if body != self:
        return

    is_on_water = true

func _on_exit_river(body:Node2D) -> void:
    if body != self:
        return

    is_on_water = false

func _on_end_zone_reached(end_zone: Node) -> void:

    _disable_interaction()
    position.x = round(position.x / 32) * 32

    EventBus.emit_signal("end_zone_reached", self)


func _die(method: DieMethod) -> void:
    if not is_alive:
        return

    _disable_interaction()
    reparent.call_deferred(_death_layer)


    rotation = 0 if method == DieMethod.Drown else rotation
    animation_player.play(die_animations[method])


func _disable_interaction() -> void:
    is_alive = false
    collision_shape.set_disabled.call_deferred(true)

func _drown_animation_started() -> void:
    water_particles_emitter.emitting = true
    EventBus.emit_signal("frog_drown_started", self)

func _drown_animation_finished() -> void:
    water_particles_emitter.emitting = false
    EventBus.emit_signal("frog_drown_finished", self)

func _ran_over_animation_started() -> void:
    blood_particles_emitter.emitting = true
    blood_particles_emitter.one_shot = true
    EventBus.emit_signal("frog_ran_over_started", self)

func _ran_over_animation_finished() -> void:
    EventBus.emit_signal("frog_ran_over_finished", self)
