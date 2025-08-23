class_name Item
extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(onBodyEntered)

func _physics_process(delta: float) -> void:
	velocity.y+=1000*delta
	move_and_slide()

func onBodyEntered(player:Player)->void:
	queue_free()
	EffectPlayer(player)

func EffectPlayer(player:Player)->void:
	player.atkCd_=0.2
