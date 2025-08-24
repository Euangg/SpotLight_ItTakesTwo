class_name Bullet_Popcorn
extends Bullet

@onready var timer: Timer = $Timer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	collision_shape_2d.rotation=sprite_2d.rotation
	velocity.y+=600*delta
	global_position+=velocity*delta

func Emit(p:Player):
	global_position=p.global_position-Vector2(0,25)
	from=p
	stunTime=p.atkStunTime_
	power=p.atkPower_
	velocity=Vector2(p.direction_*700,-200)
	scale.x=scale.x*p.direction_
	modulate=p.ammoModulate
	Global.nodeAmmo.add_child(self)
	var sfx=Global.SFX_SHOOT_POPCORN.instantiate()
	p.add_child(sfx)
	timer.start(5)

func HitPlayer(p:Player):
	sprite_2d.visible=false
	gpu_particles_2d.emitting=false
	timer.start(1)
	var buff=1 if p.timer_crab.is_stopped() else 0.5
	var buff2=1+p.damageAccumulate/10
	var fx=power*buff*buff2*sign(velocity.x)
	HurtPlayer(p,Vector2(fx,0))

func _on_timer_timeout() -> void:
	queue_free()
