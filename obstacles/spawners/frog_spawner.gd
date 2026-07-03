extends Node2D
class_name FrogSpawner

var frog_scene:PackedScene = preload("res://player/frog.tscn")

@export var river_zone:Area2D
@export var end_zone_layer:Node2D
@export var target_layer:Node2D
@export var death_layer:Node2D

func spawn() -> void:
    var frog:Frog = frog_scene.instantiate()
    frog.setup(river_zone, end_zone_layer, death_layer)
    frog.global_position = global_position
    
    target_layer.add_child(frog)

