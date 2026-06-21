extends Node2D

var tree_log_scene:PackedScene = preload("res://obstacles/tree_log.tscn")
var crocodile_scene:PackedScene = preload("res://obstacles/crocodile.tscn")

const SPEED = 200
const MINIMUM_DELAY = 5
const MAXIMUM_DELAY = 10

@export var target_layer:Node2D
@export_enum("left", "right") var direction:String = "right"

func _ready() -> void:
	if not target_layer:
		return

	spawn()

func _get_next_obstacle_scene() -> PackedScene:
	# make 1 in 5 probable to be crocodile
	if randi_range(1, 5) == 5:
		return crocodile_scene

	return tree_log_scene



func spawn() -> void:
	var obstacle_scene = _get_next_obstacle_scene()
	var obstacle:MovingObstacle = obstacle_scene.instantiate()

	if direction == "left":
		obstacle.rotate(PI)

	target_layer.add_child(obstacle)

	var timer = get_tree().create_timer(_get_next_delay())
	timer.connect("timeout", spawn)


func _get_next_delay() -> float:
	return randf_range(MINIMUM_DELAY, MAXIMUM_DELAY)
