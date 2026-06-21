extends Control
class_name App

var game_scene:PackedScene = preload("res://game/game.tscn")
var current_game:Game

@onready var main_menu = %MainMenu
@onready var new_game_button:Button = %NewGameButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    new_game_button.connect("pressed", _on_new_game_button_pressed)

func _on_new_game_button_pressed() -> void:
    if current_game:
        current_game.queue_free()

    current_game = game_scene.instantiate()
    current_game.connect("game_over", _on_game_over)
    add_child(current_game)
    main_menu.hide()


func _on_game_over() -> void:
    if current_game:
        current_game.queue_free()

    main_menu.show()
