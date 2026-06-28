extends Node

enum Sound {
    Drown,
    Hit,
    Goal,
    Move,
    Win,
    GameStart,
    GameOver,
}


@onready var sounds: Dictionary[Sound, AudioStreamPlayer2D] = {
   Sound.Drown: $Drown,
   Sound.Hit: $Hit,
   Sound.Goal: $Goal,
   Sound.Move: $Move,
   Sound.GameStart: $GameStart,
   Sound.GameOver: $GameOver,
   Sound.Win: $Win,
}


func _ready() -> void:
   EventBus.connect("frog_moved", _on_frog_moved)
   EventBus.connect("frog_died", _on_frog_died)
   EventBus.connect("game_over", _on_game_over)
   EventBus.connect("game_started", _on_game_started)


func _on_frog_moved() -> void:
   _play_sound(Sound.Move)

func _on_frog_died(_frog:Frog, method:Frog.DieMethod) -> void:
   var sound:Sound = Sound.Drown if method == Frog.DieMethod.Drown else Sound.Hit
   _play_sound(sound)

func _on_game_started(_lives:int) -> void:
   _play_sound(Sound.GameStart)

func _on_game_over() -> void:
   _play_sound(Sound.GameOver)


func _play_sound(id: Sound) -> void:
   sounds[id].play()
