class_name cGlobal
extends Node

const BULLET_FORK = preload("res://element/Bullet/Bullet_Fork.tscn")
const BULLET_POPCORN = preload("res://element/Bullet/Bullet_Popcorn.tscn")
const BULLET_SNOW = preload("res://element/Bullet/Bullet_Snow.tscn")
const BULLET_THIRTEEN = preload("res://element/Bullet/Bullet_Thirteen.tscn")

const SFX_SHOOT = preload("res://sfx/sfx_shoot.tscn")
const SFX_HIT = preload("res://sfx/sfx_hit.tscn")

const EFFECT_FIREWORK = preload("res://effect/Firework.tscn")

@onready var area_2d: Area2D = $Area2D

var nodeAmmo:Node2D
var nodeParticle:Node2D

func _on_area_2d_area_exited(area: Bullet) -> void:
	if area is Bullet_Fork:area.timer.start(2)
	if area is Bullet_Popcorn:area.timer.start(2)
	
