extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")
var frog_face_scene:PackedScene = preload("res://gui/life.tscn")

var lives:int = 5
const end_zones:int = 5
var finished_frogs:Array[Frog] = []

@onready var frog_spawner:Node2D = %FrogSpawner
@onready var end_zone_layer:Node2D = $GameLayer/EndZoneLayer

func _ready() -> void:
    EventBus.connect("frog_died", _on_frog_died)
    EventBus.connect("open_lilypad_reached", _on_open_lilypad_reached)
    EventBus.emit_signal("game_started", lives)

    await get_tree().create_timer(2).timeout

    frog_spawner.spawn()


func _on_open_lilypad_reached(frog: Frog, _lilypad:Lilypad) -> void:
    if frog in finished_frogs:
        return

    finished_frogs.append(frog)


    await get_tree().create_timer(1).timeout

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

    await get_tree().create_timer(1).timeout
    if is_instance_valid(frog):
        var tween:Tween = create_tween()
        tween.tween_property(frog, "modulate:a", 0, .25)
