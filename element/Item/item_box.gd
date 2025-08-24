extends Item

func EffectPlayer(player:Player)->void:
	var weapons=[Player.Weapon.FORK,Player.Weapon.POPCORN,Player.Weapon.SNOW,Player.Weapon.THIRTEEN]
	weapons.pop_at(player.weapon_)
	player.weapon_=weapons.pick_random()
	var sfx=Global.SFX_BOX.instantiate()
	player.add_child(sfx)
