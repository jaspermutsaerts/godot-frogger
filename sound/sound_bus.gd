extends Node

enum Sound {
   Drown,
   Hit,
   EndZoneReached,
   Move,
   LevelCompleted,
   GameStart,
   GameOver,
}


@onready var sounds: Dictionary[Sound, AudioStreamPlayer2D] = {
   Sound.Drown: $Drown,
   Sound.Hit: $Hit,
   Sound.EndZoneReached: $EndZoneReached,
   Sound.Move: $Move,
   Sound.GameStart: $GameStart,
   Sound.GameOver: $GameOver,
   Sound.LevelCompleted: $LevelCompleted,
}


func _ready() -> void:
   EventBus.connect("frog_moved", _on_frog_moved)
   EventBus.connect("frog_drown_started", _on_frog_drown_started)
   EventBus.connect("frog_ran_over_started", _on_frog_ran_over_started)
   EventBus.connect("end_zone_reached", _on_end_zone_reached)
   EventBus.connect("level_completed", _on_level_completed)
   EventBus.connect("game_over", _on_game_over)
   EventBus.connect("game_started", _on_game_started)


func _on_frog_moved() -> void:
   _play_sound(Sound.Move)

func _on_frog_drown_started(_frog:Frog) -> void:
   _play_sound(Sound.Drown)
   
func _on_frog_ran_over_started(_frog:Frog) -> void:
   _play_sound(Sound.Hit)   

func _on_end_zone_reached(_frog:Frog) -> void:
   _play_sound(Sound.EndZoneReached) 
   
func _on_level_completed() -> void:
   _play_sound(Sound.LevelCompleted)   

func _on_game_started(_lives:int) -> void:
   _play_sound(Sound.GameStart)

func _on_game_over() -> void:
   _play_sound(Sound.GameOver)


func _play_sound(id: Sound) -> void:
   sounds[id].play()
