extends Label

func _ready() -> void:
	visible=false
	if Global.lastWin==1:
		visible=true
		text=str(Global.winTimes)+"连胜"
