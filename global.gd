class_name cGlobal
extends Node

const HEART = preload("res://element/Heart.tscn")

const BULLET_FORK = preload("res://element/Bullet/Bullet_Fork.tscn")
const BULLET_POPCORN = preload("res://element/Bullet/Bullet_Popcorn.tscn")
const BULLET_SNOW = preload("res://element/Bullet/Bullet_Snow.tscn")
const BULLET_THIRTEEN = preload("res://element/Bullet/Bullet_Thirteen.tscn")

const ITEM_CRAB = preload("res://element/Item/Item_Crab.tscn")
const ITEM_STARBUCK = preload("res://element/Item/Item_Starbuck.tscn")
const ITEM_WALLACE = preload("res://element/Item/Item_Wallace.tscn")
const ITEM_BOX = preload("res://element/Item/Item_Box.tscn")

const SFX_SHOOT = preload("res://sfx/sfx_shoot.tscn")
const SFX_SHOOT_POPCORN = preload("res://sfx/sfx_shoot_popcorn.tscn")
const SFX_SHOOT_SNOW = preload("res://sfx/sfx_shoot_snow.tscn")
const SFX_SHOOT_THIRTEEN = preload("res://sfx/sfx_shoot_thirteen.tscn")
const SFX_HIT = preload("res://sfx/sfx_hit.tscn")
const SFX_BOX = preload("res://sfx/sfx_box.tscn")

const EFFECT_FIREWORK = preload("res://effect/Firework.tscn")
const EFFECT_TIP = preload("res://effect/Tip.tscn")

const TEXTURE_CHA1 = preload("res://assets/character/cha_1.png")
const TEXTURE_CHA2 = preload("res://assets/character/cha_2.png")

var lastWin:int=-1
var winTimes:int=0

@onready var area_2d: Area2D = $Area2D

var nodeAmmo:Node2D
var nodeParticle:Node2D
