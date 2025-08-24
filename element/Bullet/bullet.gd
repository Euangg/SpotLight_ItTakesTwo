class_name Bullet
extends Area2D

var velocity:Vector2
var from:Player
var stunTime:float
var power:float

@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	global_position+=velocity*delta


func _on_body_entered(body: Player) -> void:
	if body.get_collision_layer_value(2):
		if sprite_2d.visible==false:return
		if body.visible==false||body.showGhost:return
		if body!=from:
			HitPlayer(body)


func Emit(p:Player):pass
func HitPlayer(p:Player):pass
func HurtPlayer(p:Player,f:Vector2):
	p.animation_player.play("hurt")
	p.hurtNum_+=1
	p.timerStun.start(stunTime)
	p.f_=f
	var sfx=Global.SFX_HIT.instantiate()
	p.add_child(sfx)
	p.damageAccumulate+=1
	var blood=Global.EFFECT_FIREWORK.instantiate()
	blood.position=p.marker_blood.global_position
	blood.modulate=from.hitModulate
	Global.nodeParticle.add_child(blood)
	var tip=Global.EFFECT_TIP.instantiate()
	Global.nodeParticle.add_child(tip)
	tip.SetContent(str(int(p.damageAccumulate)))
	tip.position=p.global_position
	tip.modulate=from.hitModulate
