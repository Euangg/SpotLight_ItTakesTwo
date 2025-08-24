extends Item

func EffectPlayer(player:Player)->void:
	var weapons=[Player.Weapon.FORK,Player.Weapon.POPCORN,Player.Weapon.SNOW,Player.Weapon.THIRTEEN]
	weapons.pop_at(player.weapon_)
	player.weapon_=weapons.pick_random()
	var sfx=Global.SFX_BOX.instantiate()
	player.add_child(sfx)
	
	var tip=Global.EFFECT_TIP.instantiate()
	Global.nodeParticle.add_child(tip)
	match player.weapon_:
		Player.Weapon.FORK:
			tip.SetContent("叉子 直线攻击 中规中矩")
		Player.Weapon.POPCORN:
			tip.SetContent("爆米花 抛物线攻击 剑走偏锋")
		Player.Weapon.SNOW:
			tip.SetContent("蜜雪冰城 激光 超强击退 超慢攻速")
		Player.Weapon.THIRTEEN:
			tip.SetContent("十三香 粉末攻击 超强击退 超短距离")
	tip.position=player.global_position
	
