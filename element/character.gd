class_name Player
extends CharacterBody2D
const BULLET = preload("res://element/Bullet.tscn")
const SFX_SHOOT = preload("res://sfx/sfx_shoot.tscn")
const SFX_JUMP = preload("res://sfx/sfx_jump.tscn")
enum State{
	IDLE,
	RUN,
	RISE,
	FALL,
	ATTACK,
	HURT,
}
enum Direction{LEFT=-1,RIGHT=1}

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
var life_:int=3
var spawnPos_:Vector2
var atkCd_:float=0.4
var atkStunTime_:float=0.15
var atkPower_:float=10000
@export var input_w:StringName
@export var input_s:StringName
@export var input_a:StringName
@export var input_d:StringName
@export var input_j:StringName
@export var speedRun:float=200

@onready var graphic: Node2D = $Graphic
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timerStun: Timer =$Timer_Stun
@onready var sfx_run: AudioStreamPlayer2D = $SFX_Run

func _ready() -> void:
	spawnPos_=global_position

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
			if animation_player.is_playing():
				#if Input.is_action_just_pressed(input_j):
					#animation_player.seek(0)
				pass
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
			State.RUN:
				animation_player.play("run")
				sfx_run.play()
			State.RISE:
				animation_player.play("rise")
			State.FALL:
				animation_player.play("fall")
			State.ATTACK:
				animation_player.play("attack",-1,0.4/atkCd_)
				var b=BULLET.instantiate()
				b.global_position=global_position-Vector2(0,25)
				b.from=self
				b.stunTime=atkStunTime_
				b.power=atkPower_
				b.velocity=Vector2.RIGHT*direction_*800
				b.scale.x=b.scale.x*direction_
				Global.nodeAmmo.add_child(b)
				var sfx=SFX_SHOOT.instantiate()
				add_child(sfx)
			State.HURT:pass
		state_=nextState
		state_time_=0
	#3.状态执行
	if state_==State.HURT:
		velocity+=f_*delta
	else:
		match state_:
			State.IDLE:
				velocity.x=0
				if Input.is_action_just_pressed(input_w):Jump()
			State.RUN:
				velocity.x=inputX*speedRun
				if Input.is_action_just_pressed(input_w):Jump()
			State.RISE:
				velocity.x=inputX*speedRun
				if Input.is_action_just_pressed(input_w):
					if skyJumpNum_>0:
						skyJumpNum_=0
						Jump()
			State.FALL:
				velocity.x=inputX*speedRun
				if Input.is_action_just_pressed(input_w):
					if skyJumpNum_>0:
						skyJumpNum_=0
						Jump()
			State.ATTACK:
				if isOnFloor&&Input.is_action_just_pressed(input_w):Jump()
				velocity.x=inputX*speedRun
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
