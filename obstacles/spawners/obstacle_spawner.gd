class_name ObstacleSpawner
extends Node2D

@export var is_enabled:bool = true
@export var obstacle_scene:PackedScene
@export var target_layer:Node2D
@export var delay:float = 5
@export var obstacle_speed:int = 200
@export var disable_rotation:bool = false
@export_enum("left", "right") var direction:String = "right"

func _ready() -> void:
    if not target_layer or not is_enabled:
        return

    spawn.call_deferred()


func spawn() -> void:
    var obstacle:MovingObstacle = obstacle_scene.instantiate()
    obstacle.set_speed(obstacle_speed if direction == "right" else -obstacle_speed)

    if direction == "left" and not disable_rotation:
        obstacle.rotate(PI)

    target_layer.add_child(obstacle)
    obstacle.global_position = global_position

    var timer = get_tree().create_timer(delay)
    timer.connect("timeout", spawn)
