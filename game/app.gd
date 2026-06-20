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
	add_child(current_game)
	main_menu.hide()
