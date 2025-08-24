extends Item
const SFX_WALLACE = preload("res://sfx/sfx_wallace.tscn")
func EffectPlayer(player:Player)->void:
	player.timer_wallace.start(10)
	player.particle_wallace.emitting=true
	var sfx=SFX_WALLACE.instantiate()
	player.add_child(sfx)
	var tip=Global.EFFECT_TIP.instantiate()
	#tip.label.text="华莱士 移速1.3倍 持续10s"
	Global.nodeParticle.add_child(tip)
	tip.SetContent("华莱士 移速1.3倍 持续10s")
	tip.position=player.global_position
	
