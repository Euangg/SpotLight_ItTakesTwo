class_name Player
extends CharacterBody2D
const SFX_JUMP = preload("res://sfx/sfx_jump.tscn")
const SFX_AWAKE = preload("res://sfx/sfx_awake.tscn")
enum State{
	IDLE,
	RUN,
	RISE,
	FALL,
	ATTACK,
	HURT,
}
enum Direction{LEFT=-1,RIGHT=1}
enum Weapon{
	FORK,
	POPCORN,
	SNOW,
	THIRTEEN
}

var state_:State=State.IDLE
var state_time_:float=0
var direction_:Direction=Direction.RIGHT:
	set(v):
		direction_=v
		if not is_node_ready():await ready
		graphic.scale.x=direction_
var hurtNum_:int=0
var skyJumpNum_:int=0
var f_:Vector2=Vector2.ZERO
var life_:int=2
var spawnPos_:Vector2
var atkCd_:float
var atkStunTime_:float
var atkPower_:float
var showGhost:bool=false
var ghost_timer=0.0
var ammoModulate=0xffc2c2
var hitModulate=0xffc2c2
var damageAccumulate:float=0

@export var id:int=0
@export var weapon_:Weapon=Weapon.FORK:
	set(value):
		weapon_=value
		match value:
			Weapon.FORK:
				atkCd_=0.4
				atkStunTime_=0.15
				atkPower_=10000
			Weapon.POPCORN:
				atkCd_=0.3
				atkStunTime_=0.15
				atkPower_=10000
			Weapon.SNOW:
				atkCd_=1.5
				atkStunTime_=0.15
				atkPower_=20000
			Weapon.THIRTEEN:
				atkCd_=0.5
				atkStunTime_=0.15
				atkPower_=20000
@export var input_w:StringName
@export var input_s:StringName
@export var input_a:StringName
@export var input_d:StringName
@export var input_j:StringName
@export var speedRun:float=200

@onready var graphic: Node2D = $Graphic
@onready var sprite_2d: Sprite2D = $Graphic/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timerStun: Timer =$Timer_Stun
@onready var sfx_run: AudioStreamPlayer2D = $SFX_Run
@onready var marker_blood: Marker2D = $Marker2D_Blood
@onready var timer_starbuck: Timer = $Timer_Starbuck
@onready var timer_crab: Timer = $Timer_Crab
@onready var timer_wallace: Timer = $Timer_Wallace
@onready var timer_invincible: Timer = $Timer_Invincible
@onready var particle_wallace: GPUParticles2D = $Graphic/Particle_Wallace

func _ready() -> void:
	match id:
		0:
			sprite_2d.texture=Global.TEXTURE_CHA1
			ammoModulate=0xffc2c2ff
			hitModulate=0xffaaaaff
		1:
			sprite_2d.texture=Global.TEXTURE_CHA2
			ammoModulate=0xc2c2ffff
			hitModulate=0xaaaaffff
	spawnPos_=global_position
	weapon_=weapon_

func _process(delta: float) -> void:
	if showGhost:
		if ghost_timer<=0:
			var ghost=Sprite2D.new()
			ghost.texture=sprite_2d.texture
			ghost.hframes=sprite_2d.hframes
			ghost.vframes=sprite_2d.vframes
			ghost.frame=sprite_2d.frame
			ghost.global_position=sprite_2d.global_position
			ghost.flip_h=true if direction_==Direction.LEFT else false
			match id:
				0:ghost.modulate=Color(1.0,0.5,0.3,0.6)
				1:ghost.modulate=Color(0.3,0.5,1.0,0.6)
			get_parent().add_child(ghost)
			ghost_timer=0.03
			create_tween().tween_property(ghost,"modulate:a",0.0,0.5).set_ease(Tween.EASE_OUT)
			create_tween().tween_callback(ghost.queue_free).set_delay(0.5)
		else:ghost_timer-=delta

func _physics_process(delta: float) -> void:
	if visible==false:return
	var isOnFloor=is_on_floor()
	var inputX=Input.get_axis(input_a,input_d)
	#1.状态判断
	var nextState:State=state_
	match state_:
		State.IDLE:
			if is_zero_approx(inputX):pass
			else:nextState=State.RUN
			if velocity.y>0:nextState=State.FALL
			if velocity.y<0:nextState=State.RISE
			if Input.is_action_just_pressed(input_j):nextState=State.ATTACK
		State.RUN:
			if is_zero_approx(inputX):nextState=State.IDLE
			if velocity.y>0:nextState=State.FALL
			if velocity.y<0:nextState=State.RISE
			if Input.is_action_just_pressed(input_j):nextState=State.ATTACK
		State.RISE:
			if velocity.y>0:nextState=State.FALL
			if Input.is_action_just_pressed(input_j):nextState=State.ATTACK
		State.FALL:
			if velocity.y<0:nextState=State.RISE
			if is_on_floor():nextState=State.IDLE
			if Input.is_action_just_pressed(input_j):nextState=State.ATTACK
		State.ATTACK:
			if animation_player.is_playing():pass
			else:
				if is_on_floor():
					nextState=State.IDLE
				else:
					if velocity.y>0:nextState=State.FALL
					elif velocity.y<0:nextState=State.RISE
		State.HURT:
			if timerStun.is_stopped():
				skyJumpNum_=1
				if velocity.y:nextState=State.FALL
				else :nextState=State.IDLE
	if hurtNum_>0:
		nextState=State.HURT
		hurtNum_-=1
	#2.状态切换
	if nextState==state_:pass
	else:
		match state_:
			State.RUN:sfx_run.stop()
		match  nextState:
			State.IDLE:
				animation_player.play("idle")
				skyJumpNum_=0
				showGhost=false
			State.RUN:
				animation_player.play("run")
				sfx_run.play()
			State.RISE:
				animation_player.play("rise")
			State.FALL:
				animation_player.play("fall")
			State.ATTACK:
				var buff=1 if timer_starbuck.is_stopped() else 1.3
				animation_player.play("attack",-1,0.4/atkCd_*buff)
				var b:Bullet
				match weapon_:
					Weapon.FORK:b=Global.BULLET_FORK.instantiate()
					Weapon.POPCORN:b=Global.BULLET_POPCORN.instantiate()
					Weapon.SNOW:b=Global.BULLET_SNOW.instantiate()
					Weapon.THIRTEEN:b=Global.BULLET_THIRTEEN.instantiate()
				b.Emit(self)
				
			State.HURT:pass
		state_=nextState
		state_time_=0
	#3.状态执行
	if state_==State.HURT:
		velocity+=f_*delta
	else:
		var buff=1 if timer_wallace.is_stopped() else 1.3
		match state_:
			State.IDLE:
				velocity.x=0
				if Input.is_action_just_pressed(input_w):Jump()
			State.RUN:
				velocity.x=inputX*speedRun*buff
				if Input.is_action_just_pressed(input_w):Jump()
			State.RISE:
				velocity.x=inputX*speedRun*buff
				if Input.is_action_just_pressed(input_w):
					if skyJumpNum_>0:
						skyJumpNum_=0
						var sfx=SFX_AWAKE.instantiate()
						add_child(sfx)
						velocity.y=-400
						showGhost=true
			State.FALL:
				velocity.x=inputX*speedRun*buff
				if Input.is_action_just_pressed(input_w):
					if skyJumpNum_>0:
						skyJumpNum_=0
						var sfx=SFX_AWAKE.instantiate()
						add_child(sfx)
						velocity.y=-400
						showGhost=true
			State.ATTACK:
				if isOnFloor&&Input.is_action_just_pressed(input_w):Jump()
				velocity.x=inputX*speedRun*buff
		if not is_zero_approx(inputX):
			direction_=Direction.LEFT if inputX<0 else Direction.RIGHT
		
	if Input.is_action_just_pressed(input_s):set_collision_mask_value(4,0)
	if Input.is_action_just_released(input_s):set_collision_mask_value(4,1)
	state_time_+=delta
	velocity.y+=1000*delta
	move_and_slide()

func Jump()->void:
	var sfx=SFX_JUMP.instantiate()
	add_child(sfx)
	velocity.y=-500

func _on_timer_wallace_timeout() -> void:
	particle_wallace.emitting=false
