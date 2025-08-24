class_name EffectTip
extends Node2D

@onready var label: Label = $Label

func SetContent(str:String):
	label.text=str
