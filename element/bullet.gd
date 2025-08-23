class_name Bullet
extends Area2D

const SFX_HIT = preload("res://sfx/sfx_hit.tscn")

var velocity:Vector2
var from:Player
var stunTime:float
var power:float

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position+=velocity*delta

func _on_body_entered(body: Player) -> void:
	if sprite_2d.visible==false:return
	if body.visible==false||body.showGhost:return
	if body.get_collision_layer_value(2):
		if body!=from:
			sprite_2d.visible=false
			gpu_particles_2d.emitting=false
			timer.start(1)
			var player:Player=body
			player.animation_player.play("hurt")
			player.hurtNum_+=1
			player.timerStun.start(stunTime)
			player.f_=power*velocity.normalized()
			var sfx=SFX_HIT.instantiate()
			player.add_child(sfx)


func _on_timer_timeout() -> void:
	queue_free()
