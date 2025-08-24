extends Item
const SFX_STARBUCK = preload("res://sfx/sfx_starbuck.tscn")

func EffectPlayer(player:Player)->void:
	player.timer_starbuck.start(10)
	var sfx=SFX_STARBUCK.instantiate()
	player.add_child(sfx)
	var tip=Global.EFFECT_TIP.instantiate()
	#tip.label.text="星巴克 攻速1.3倍 持续10s"
	Global.nodeParticle.add_child(tip)
	tip.SetContent("星巴克 攻速1.3倍 持续10s")
	tip.position=player.global_position
	
