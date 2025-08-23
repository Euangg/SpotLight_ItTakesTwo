class_name Bullet
extends Area2D

const SFX_HIT = preload("res://sfx/sfx_hit.tscn")

var velocity:Vector2
var from:Node

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position+=velocity*delta

func _on_body_entered(body: Node2D) -> void:
	if body.visible==false:return
	if body.get_collision_layer_value(2):
		if body!=from:
			queue_free()
			var player:Player=body
			player.animation_player.play("hurt")
			player.hurtNum_+=1
			player.timer.start(0.15)
			player.f_=10000*velocity.normalized()
			var sfx=SFX_HIT.instantiate()
			player.add_child(sfx)
