extends Area2D
class_name Lilypad

var occupied:bool = false


func _ready() -> void:
    connect("body_entered", _on_body_entered)


func _on_body_entered(body:Node2D) -> void:
    if not body is Frog:
        return

    if occupied:
        EventBus.emit_signal("occupied_lilypad_reached", body, self)
    else:
        occupied = true
        EventBus.emit_signal("open_lilypad_reached", body, self)
