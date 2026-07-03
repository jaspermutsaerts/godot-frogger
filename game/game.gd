extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")
var frog_face_scene:PackedScene = preload("res://gui/life.tscn")

var lives:int = 5
const end_zones:int = 5
var finished_frogs:Array[Frog] = []

@onready var frog_spawner:Node2D = %FrogSpawner

func _ready() -> void:
    EventBus.connect("frog_died", _on_frog_died)    
    EventBus.connect("end_zone_reached", _on_end_zone_reached)    
    EventBus.emit_signal("game_started", lives)

    await get_tree().create_timer(2).timeout

    frog_spawner.spawn()


func _on_end_zone_reached(frog: Frog) -> void:
    if frog in finished_frogs:
        return

    finished_frogs.append(frog)
    

    await get_tree().create_timer(1).timeout    
    print(end_zones, finished_frogs.size())
    if end_zones == finished_frogs.size():
        EventBus.emit_signal("level_completed")
        return

    frog_spawner.spawn()

func _on_frog_died(frog: Frog) -> void:
    lives -= 1
    EventBus.emit_signal("life_lost", lives)

    await get_tree().create_timer(1).timeout    

    if lives == 0:
        EventBus.emit_signal("game_over")
        return

    frog_spawner.spawn()
