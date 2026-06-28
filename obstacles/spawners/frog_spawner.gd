extends Node2D
class_name FrogSpawner

var frog_scene:PackedScene = preload("res://player/frog.tscn")

@export var river_zone:Area2D
@export var target_layer:Node2D
@export var death_layer:Node2D

func spawn() -> void:
    var frog:Frog = frog_scene.instantiate()
    frog.setup(river_zone, death_layer)
    target_layer.add_child(frog)
    frog.global_position = global_position

