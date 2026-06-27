extends Control
class_name App

var game_scene:PackedScene = preload("res://game/game.tscn")
var current_game:Game

@onready var main_menu = %MainMenu
@onready var new_game_button:Button = %NewGameButton
@onready var game_over_label:RichTextLabel = %GameOverLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    game_over_label.hide()

    new_game_button.connect("pressed", _on_new_game_button_pressed)

    EventBus.connect("game_over", _on_game_over)

func _on_new_game_button_pressed() -> void:
    if current_game:
        current_game.queue_free()

    current_game = game_scene.instantiate()
    add_child(current_game)
    main_menu.hide()
    game_over_label.hide()


func _on_game_over() -> void:
    if current_game:
        current_game.queue_free()

    main_menu.show()
    game_over_label.show()
