extends CharacterBody2D

enum State{
	IDLE,
	RUN,
	RISE,
	FALL,
	ATK,
	HURT,
	DIE,
}
enum Direction{LEFT=-1,RIGHT=1}


var state_:State=State.IDLE
var state_time_:float=0
var direction_:Direction=Direction.RIGHT:
	set(v):
		direction_=v
		if not is_node_ready():await ready
		graphic.scale.x=direction_
@export var input_w:StringName
@export var input_s:StringName
@export var input_a:StringName
@export var input_d:StringName
@export var speedRun:float=100

@onready var graphic: Node2D = $Graphic
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var inputX=Input.get_axis(input_a,input_d)
	#1.状态判断
	var nextState:State=state_
	match state_:
		State.IDLE:
			if is_zero_approx(inputX):pass
			else:nextState=State.RUN
			if velocity.y>0:nextState=State.FALL
			if velocity.y<0:nextState=State.RISE
		State.RUN:
			if is_zero_approx(inputX):nextState=State.IDLE
			if velocity.y>0:nextState=State.FALL
			if velocity.y<0:nextState=State.RISE
		State.RISE:
			if velocity.y>0:nextState=State.FALL
		State.FALL:
			if velocity.y<0:nextState=State.RISE
			if is_on_floor():nextState=State.IDLE
	#2.状态切换
	if nextState==state_:pass
	else:
		match  nextState:
			State.IDLE:
				animation_player.play("idle")
			State.RUN:
				animation_player.play("run")
			State.RISE:
				animation_player.play("rise")
			State.FALL:
				animation_player.play("fall")
		state_=nextState
		state_time_=0
	#3.状态执行
	match state_:
		State.IDLE:
			velocity.x=0
			if Input.is_action_just_pressed(input_w):velocity.y=-400
		State.RUN:
			velocity.x=inputX*speedRun
			if Input.is_action_just_pressed(input_w):velocity.y=-400
		State.RISE:
			velocity.x=inputX*speedRun
		State.FALL:
			velocity.x=inputX*speedRun
	#绝对执行
	state_time_+=delta
	if not is_zero_approx(inputX):
		direction_=Direction.LEFT if inputX<0 else Direction.RIGHT
	if Input.is_action_just_pressed(input_s):set_collision_mask_value(1,0)
	if Input.is_action_just_released(input_s):set_collision_mask_value(1,1)
	move(delta)


func move(delta:float)->void:
	velocity.y+=1000*delta
	move_and_slide()
