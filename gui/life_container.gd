extends Control
class_name LifeContainer

var life_scene:PackedScene = preload("res://gui/life.tscn")

@onready var container:Container = $HBoxContainer


func _ready() -> void:
    EventBus.connect("game_started", _on_game_started)
    EventBus.connect("life_lost", _on_life_lost)


func _on_game_started(lives:int) -> void:
    for _i in lives:
        var life:Control = life_scene.instantiate()
        container.add_child(life)


func _on_life_lost(left_lives:int) -> void:
    while container.get_child_count() > left_lives:
        container.remove_child(container.get_child(-1))
