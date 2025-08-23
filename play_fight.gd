extends Node2D
@onready var camera: Camera2D = $Camera2D
@onready var character1: Player = $Character
@onready var character2: Player = $Character2
@onready var node_ammo: Node2D = $NodeAmmo

func _ready() -> void:
	Global.nodeAmmo=node_ammo

func _physics_process(delta: float) -> void:
	camera.global_position.y=(character1.global_position.y+character2.global_position.y)/2


func _on_area_2d_dead_zone_body_entered(player: Player) -> void:
	player.life_-=1
	if player.life_<0:
		player.global_position.y=get_viewport_rect().size.y/2
		player.visible=false
	else:player.global_position=player.spawnPos_
		
