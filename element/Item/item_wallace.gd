extends Item
const SFX_WALLACE = preload("res://sfx/sfx_wallace.tscn")
func EffectPlayer(player:Player)->void:
	player.timer_wallace.start(10)
	player.particle_wallace.emitting=true
	var sfx=SFX_WALLACE.instantiate()
	player.add_child(sfx)
