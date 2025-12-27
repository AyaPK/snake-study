extends Node2D

const BODY_PART = preload("uid://cgei2p1fpmduj")

@onready var checker: RayCast2D = $Head/Checker

var direction: String = "down"
var move_speed: float = 0.05
var new_pos: Vector2
var old_pos: Vector2
var accepting_input: bool = true
var should_spawn_part: bool = false
var alive: bool = true

func _ready() -> void:
	$Timer.wait_time = move_speed
	$Timer.start()
	$Head.color.color = "#ff1619"

func _on_timer_timeout() -> void:
	if alive:
		$Timer.start()
		_move_snake()

func _move_snake() -> void:
	if direction == "down":
		checker.rotation = 0
	elif direction == "right":
		checker.rotation = 4.7
	elif direction == "left":
		checker.rotation = 1.6
	elif direction == "up":
		checker.rotation = 3.2
	
	check_ahead()
	
	old_pos = $Head.global_position
	
	if direction == "down":
		$Head.global_position.y += 10
		if $Head.global_position.y > 250:
			$Head.global_position.y = 0
	elif direction == "right":
		$Head.global_position.x += 10
		if $Head.global_position.x > 250:
			$Head.global_position.x = 0
	elif direction == "left":
		$Head.global_position.x -= 10
		if $Head.global_position.x < 0:
			$Head.global_position.x = 250
	elif direction == "up":
		$Head.global_position.y -= 10
		if $Head.global_position.y < 0:
			$Head.global_position.y = 250
	new_pos = $Head.global_position
	for _c in get_children():
		if _c is StaticBody2D and _c is not Head:
			new_pos = _c.global_position
			_c.global_position = old_pos
			old_pos = new_pos
			
	if should_spawn_part:
		spawn_body_part()
		
	accepting_input = true

func _process(_delta: float) -> void:
	if accepting_input:
		if Input.is_action_pressed("ui_right") and direction != "left":
			direction = "right"
			accepting_input = false
		elif Input.is_action_pressed("ui_down") and direction != "up":
			direction = "down"
			accepting_input = false
		elif Input.is_action_pressed("ui_up") and direction != "down":
			direction = "up"
			accepting_input = false
		elif Input.is_action_pressed("ui_left") and direction != "right":
			direction = "left"
			accepting_input = false

func check_ahead() -> void:
	checker.force_raycast_update()

	if checker.is_colliding():
		var collider = checker.get_collider()
		if collider is Food:
			collider.queue_free()
			await collider.tree_exited
			get_parent().spawn_food()
			should_spawn_part = true
		elif collider is StaticBody2D and collider is not Head:
			alive = false
			for _c in get_children():
				if _c is BodyPart:
					_c.color.color = "#111111"

func spawn_body_part():
	var new_part: StaticBody2D = BODY_PART.instantiate()
	add_child(new_part)
	new_part.global_position = new_pos
	should_spawn_part = false
	
