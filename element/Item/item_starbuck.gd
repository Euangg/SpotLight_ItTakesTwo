extends Item
const SFX_STARBUCK = preload("res://sfx/sfx_starbuck.tscn")

func EffectPlayer(player:Player)->void:
	player.timer_starbuck.start(10)
	var sfx=SFX_STARBUCK.instantiate()
	player.add_child(sfx)
