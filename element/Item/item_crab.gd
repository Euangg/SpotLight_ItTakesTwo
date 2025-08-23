extends Item
const SFX_CRAB = preload("res://sfx/sfx_crab.tscn")
func EffectPlayer(player:Player)->void:
	player.timer_crab.start(10)
	var sfx=SFX_CRAB.instantiate()
	player.add_child(sfx)
