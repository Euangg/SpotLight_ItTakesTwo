class_name Bullet
extends Area2D

const SFX_HIT = preload("res://sfx/sfx_hit.tscn")

var velocity:Vector2
var from:Player
var stunTime:float
var power:float

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position+=velocity*delta

func _on_body_entered(body: Player) -> void:
	if body.visible==false||body.showGhost:return
	if body.get_collision_layer_value(2):
		if body!=from:
			queue_free()
			var player:Player=body
			player.animation_player.play("hurt")
			player.hurtNum_+=1
			player.timerStun.start(stunTime)
			player.f_=power*velocity.normalized()
			var sfx=SFX_HIT.instantiate()
			player.add_child(sfx)
