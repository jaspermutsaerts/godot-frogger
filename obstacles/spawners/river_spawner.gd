extends ObstacleSpawner
class_name RiverSpawner

var short_tree_log_scene:PackedScene = preload("res://obstacles/short_tree_log.tscn")
var medium_tree_log_scene:PackedScene = preload("res://obstacles/medium_tree_log.tscn")
var long_tree_log_scene:PackedScene = preload("res://obstacles/long_tree_log.tscn")
var crocodile_scene:PackedScene = preload("res://obstacles/crocodile.tscn")

func _get_next_obstacle_scene() -> PackedScene:
    # make 1 in 5 probable to be crocodile
    if randi_range(1, 6) == 5:
        return crocodile_scene



    var tree_type = randi_range(1, 5)

    if tree_type == 1:
        return short_tree_log_scene

    if tree_type == 5:
        return long_tree_log_scene


    return medium_tree_log_scene
