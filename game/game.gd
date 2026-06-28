extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")

var lives:int = 5

@onready var frog_spawner:Node2D = %FrogSpawner

func _ready() -> void:
    EventBus.connect("frog_died", _on_frog_died)    
    EventBus.emit_signal("game_started", lives)

    await get_tree().create_timer(2).timeout

    frog_spawner.spawn()


func _on_frog_died(frog: Frog) -> void:
    lives -= 1
    EventBus.emit_signal("life_lost", lives)

    await get_tree().create_timer(1).timeout    

    if lives == 0:
        EventBus.emit_signal("game_over")
        return

    frog_spawner.spawn()
