extends Node2D
@onready var camera: Camera2D = $Camera2D
@onready var character1: Player = $Character
@onready var character2: Player = $Character2

func _physics_process(delta: float) -> void:
	camera.global_position.y=(character1.global_position.y+character2.global_position.y)/2
