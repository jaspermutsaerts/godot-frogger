extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")

var lives:int = 5

@onready var frog_spawner:Node2D = %FrogSpawner

func _ready() -> void:
    EventBus.connect("frog_died", _on_frog_died)

    await get_tree().create_timer(3).timeout
    frog_spawner.spawn()


func _on_frog_died(frog: Frog) -> void:
    lives -= 1
    print("on frog died")


    await get_tree().create_timer(2).timeout
    if is_instance_valid(frog):
        frog.queue_free()

    if lives == 0:
        EventBus.emit_signal("game_over")
        return

    frog_spawner.spawn()
