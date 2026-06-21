@abstract
class_name ObstacleSpawner
extends Node2D

@abstract func _get_next_obstacle_scene() -> PackedScene

@export var target_layer:Node2D
@export var minimum_delay:int = 5
@export var maximum_delay:int = 10
@export var obstacle_speed:int = 200
@export_enum("left", "right") var direction:String = "right"

func _ready() -> void:
    if not target_layer:
        return

    # var timer = get_tree().create_timer(_get_next_delay())
    # timer.connect("timeout", spawn)
    spawn.call_deferred()


func spawn() -> void:
    var obstacle_scene = _get_next_obstacle_scene()
    var obstacle:MovingObstacle = obstacle_scene.instantiate()
    obstacle.set_speed(obstacle_speed)

    if direction == "left":
        obstacle.rotate(PI)

    target_layer.add_child(obstacle)
    obstacle.global_position = global_position

    var timer = get_tree().create_timer(_get_next_delay())
    timer.connect("timeout", spawn)


func _get_next_delay() -> float:
    return randf_range(minimum_delay, maximum_delay)


# 1300
# 850

# 450 225

# 1300 - 225 = 1075
