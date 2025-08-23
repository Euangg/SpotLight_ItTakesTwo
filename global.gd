class_name cGlobal
extends Node
@onready var area_2d: Area2D = $Area2D

var nodeAmmo:Node2D
var nodeParticle:Node2D

func _on_area_2d_area_exited(area: Bullet) -> void:
	area.timer.start(2)
