class_name Food extends Area2D


func _ready() -> void:
	global_position = random_position()

func random_position() -> Vector2:
	var x: int = randi_range(1, 24) * 10
	var y: int = randi_range(1, 24) * 10
	return Vector2(x, y)
