extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")

var frog:Frog

@onready var game_layer:Node2D = $GameLayer
@onready var player_spawn_point:Node2D = %PlayerSpawnPoint

func _ready() -> void:
    frog = frog_scene.instantiate()
    frog.global_position = player_spawn_point.global_position
    game_layer.add_child(frog)
