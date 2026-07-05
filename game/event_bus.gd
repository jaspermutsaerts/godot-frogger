extends Node

signal game_started(current_lives:int)
signal game_over
signal frog_moved
signal frog_drown_started(frog:Frog)
signal frog_drown_finished(frog:Frog)
signal frog_ran_over_started(frog:Frog)
signal frog_ran_over_finished(frog:Frog)
signal frog_died(frog:Frog) # triggered when any death signal triggered
signal life_lost(current_lives:int)
signal open_lilypad_reached(frog:Frog, lilypad:Lilypad)
signal occupied_lilypad_reached(frog:Frog, lilypad:Lilypad)
signal level_completed

func _ready() -> void:
    EventBus.connect("frog_drown_finished", _on_frog_death_signal)
    EventBus.connect("frog_ran_over_finished", _on_frog_death_signal)

func _on_frog_death_signal(frog: Frog) -> void:
    EventBus.emit_signal("frog_died", frog)
