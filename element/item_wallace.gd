extends Item

func EffectPlayer(player:Player)->void:
	player.timer_wallace.start(10)
	player.particle_wallace.emitting=true
