extends Node2D
const SFX_DEAD1 = preload("res://sfx/sfx_dead1.tscn")
const SFX_DEAD2 = preload("res://sfx/sfx_dead2.tscn")

@onready var camera: Camera2D = $Camera2D
@onready var character1: Player = $Character
@onready var character2: Player = $Character2
@onready var node_ammo: Node2D = $NodeAmmo
@onready var node_particle: Node2D = $NodeParticle
@onready var node_item: Node2D = $NodeItem
@onready var timer_item: Timer = $TimerItem
@onready var node_mark_item: Node2D = $NodeMarkItem
@onready var ui_p1: Control = $UI/P1
@onready var ui_p2: Control = $UI/P2
@onready var ui_die: Control = $UI/Die
@onready var ui_end: CanvasLayer = $UiEnd
@onready var timer_end: Timer = $TimerEnd

func _ready() -> void:
	Global.nodeAmmo=node_ammo
	Global.nodeParticle=node_particle
	for i in character1.life_:
		var pos=Vector2(25+30*i,500)
		var heart =Global.HEART.instantiate()
		heart.position=pos
		ui_p1.add_child(heart)
	for i in character2.life_:
		var pos=Vector2(960-25-30*i,500)
		var heart =Global.HEART.instantiate()
		heart.position=pos
		ui_p2.add_child(heart)
	ui_end.visibility_changed.connect(onShowUiEnd)
	ui_end.process_mode=Node.PROCESS_MODE_WHEN_PAUSED

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):get_tree().change_scene_to_file("res://Theme.tscn")
	camera.global_position.y=(character1.global_position.y+character2.global_position.y)/2
	if node_item.get_child_count()>0:pass
	else:if timer_item.is_stopped():timer_item.start()

func _on_area_2d_dead_zone_body_entered(player: Player) -> void:
	player.life_-=1
	if player.life_<0:
		player.global_position.y=get_viewport_rect().size.y/2
		player.visible=false
		player.showGhost=false
		var sfx=SFX_DEAD2.instantiate()
		player.add_child(sfx)
		timer_end.start()
		var winner=0
		match player.id:
			0:winner=1
			1:winner=0
		if Global.lastWin==winner:Global.winTimes+=1
		else:
			Global.lastWin=winner
			Global.winTimes=1
	else:	
		player.global_position=player.spawnPos_
		var sfx=SFX_DEAD1.instantiate()
		player.add_child(sfx)
		player.damageAccumulate=0
		var heart:Heart
		match player.id:
			0:heart=ui_p1.get_child(-1)
			1:heart=ui_p2.get_child(-1)
		heart.animation_player.play("die")
		heart.reparent(ui_die)

func _on_timer_item_timeout() -> void:
	var items=[Global.ITEM_STARBUCK,Global.ITEM_WALLACE,Global.ITEM_CRAB,Global.ITEM_BOX]
	var rand_item:PackedScene=items.pick_random()
	var children=node_mark_item.get_children()
	if children.size()>0:
		var random_child:Marker2D=children.pick_random()
		var item:Item=rand_item.instantiate()
		item.global_position=random_child.global_position
		node_item.add_child(item)
func _on_timer_end_timeout() -> void:
	ui_end.visible=true


func onShowUiEnd():
	if ui_end.visible==true:
		get_tree().paused=true
