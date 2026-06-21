extends ObstacleSpawner
class_name RoadSpawner

var car_scene:PackedScene = preload("res://obstacles/car.tscn")
var truck_scene:PackedScene = preload("res://obstacles/truck.tscn")

func _get_next_obstacle_scene() -> PackedScene:
    # make 1 in 5 probable to be truck
    if randi_range(1, 5) == 5:
        return truck_scene

    return car_scene
