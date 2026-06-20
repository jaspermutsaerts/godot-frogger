extends Node2D

var obstacle_scene:PackedScene = preload("res://obstacles/car.tscn")


const MINIMUM_DELAY = 2
const MAXIMUM_DELAY = 5

var timer:Timer
@export var target_layer:Node2D
@export_enum("left", "right") var direction:String = "right"

func _ready() -> void:
	if not target_layer:
		return

	spawn()


func spawn() -> void:
	var obstacle:CharacterBody2D = obstacle_scene.instantiate()
	
	if direction == "left":
		obstacle.rotate(PI)

	target_layer.add_child(obstacle)

	var timer =  get_tree().create_timer(_get_next_delay())
	timer.connect("timeout", spawn)


func _get_next_delay() -> float: 
	return randf_range(MINIMUM_DELAY, MAXIMUM_DELAY)