extends Node2D

const FOOD = preload("uid://bdogsmka4mp6q")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_food()

func spawn_food() -> void:
	var food: Food = FOOD.instantiate()
	add_child(food)
