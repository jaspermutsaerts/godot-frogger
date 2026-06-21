extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")

var frog:Frog
var lives:int = 5

@onready var game_layer:Node2D = $GameLayer
@onready var player_spawn_point:Node2D = %PlayerSpawnPoint

signal game_over

func _ready() -> void:
    spawn_frog()

func spawn_frog() -> void:
    frog = frog_scene.instantiate()
    frog.global_position = player_spawn_point.global_position
    frog.connect("died", _on_frog_died)
    game_layer.add_child(frog)


func _on_frog_died() -> void:
    lives -= 1
    print("on frog died")

    if lives == 0:
        emit_signal("game_over")
        return

    await get_tree().create_timer(2).timeout
    frog.queue_free()
    spawn_frog()
