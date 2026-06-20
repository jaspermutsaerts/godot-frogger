extends Node2D
class_name Game

var frog_scene:PackedScene = preload("res://player/frog.tscn")

var frog:Frog

func _ready() -> void:
	frog = frog_scene.instantiate() as Frog
	add_child(frog)




