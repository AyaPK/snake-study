extends Node2D

var direction: String = "down"
var move_speed: float = 0.2

var new_pos: Vector2
var old_pos: Vector2

var accepting_input: bool = true

func _ready() -> void:
	$Timer.wait_time = move_speed
	$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.start()
	_move_snake()

func _move_snake() -> void:
	old_pos = $Head.global_position
	
	if direction == "down":
		$Head.global_position.y += 10
	elif direction == "right":
		$Head.global_position.x += 10
	elif direction == "left":
		$Head.global_position.x -= 10
	elif direction == "up":
		$Head.global_position.y -= 10
	new_pos = $Head.global_position
	for _c in get_children():
		if _c is StaticBody2D and _c is not Head:
			new_pos = _c.global_position
			_c.global_position = old_pos
			old_pos = new_pos
	accepting_input = true
	pass

func _process(delta: float) -> void:
	if accepting_input:
		accepting_input = false
		if Input.is_action_pressed("ui_right") and direction != "left":
			direction = "right"
		elif Input.is_action_pressed("ui_down") and direction != "up":
			direction = "down"
		elif Input.is_action_pressed("ui_up") and direction != "down":
			direction = "up"
		elif Input.is_action_pressed("ui_left") and direction != "right":
			direction = "left"
