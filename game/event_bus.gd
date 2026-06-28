extends Node

signal game_started(current_lives:int)
signal game_over
signal frog_moved
signal frog_died(frog:Frog, method:Frog.DieMethod)
signal life_lost(current_lives:int)
signal frog_entered_river
signal frog_exited_river
