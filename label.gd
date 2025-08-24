extends Label


func _ready() -> void:
	visible=false
	if Global.lastWin==0:
		visible=true
		text=str(Global.winTimes)+"连胜"
