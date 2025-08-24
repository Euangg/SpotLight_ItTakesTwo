class_name Bullet_Thirteen
extends Bullet

@onready var timer: Timer = $Timer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
var dir:int=1

func Emit(p:Player):
	global_position=p.global_position-Vector2(0,25)
	from=p
	stunTime=p.atkStunTime_
	power=p.atkPower_
	scale.x=scale.x*p.direction_
	modulate=p.ammoModulate
	Global.nodeAmmo.add_child(self)
	var sfx=Global.SFX_SHOOT_THIRTEEN.instantiate()
	p.add_child(sfx)
	timer.start(0.2)
	dir=p.direction_
	gpu_particles_2d.emitting=true
	gpu_particles_2d.modulate.a=timer.time_left/0.3

func HitPlayer(p:Player):
	if p.timer_invincible.is_stopped():
		var buff=1 if p.timer_crab.is_stopped() else 0.5
		var buff2=1+p.damageAccumulate/10
		var fx=power*buff*buff2*dir
		HurtPlayer(p,Vector2(fx,0))
		p.timer_invincible.start(0.4)

func _on_timer_timeout() -> void:
	queue_free()
