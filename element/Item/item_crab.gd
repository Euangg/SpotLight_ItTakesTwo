extends Item
const SFX_CRAB = preload("res://sfx/sfx_crab.tscn")
func EffectPlayer(player:Player)->void:
	player.timer_crab.start(10)
	var sfx=SFX_CRAB.instantiate()
	player.add_child(sfx)
	var tip=Global.EFFECT_TIP.instantiate()
	#tip.label.text="芝士汉堡 受力-50% 持续10s"
	Global.nodeParticle.add_child(tip)
	tip.SetContent("芝士汉堡 受力-50% 持续10s")
	tip.position=player.global_position
	
