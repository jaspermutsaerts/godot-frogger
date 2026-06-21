extends CharacterBody2D
class_name Frog


const MOVE_SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    velocity = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_up"):
        position.y -= MOVE_SPEED
        rotation = 0
    elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
        var direction = Input.get_axis("ui_left", "ui_right")
        position.x += MOVE_SPEED * direction
        rotation = PI  *.5 * direction


    var collision = move_and_collide(Vector2(0, 0), true)

    if collision:
        print("hit something")



    pass
