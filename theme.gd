extends Control


func _on_button_pressed() -> void:
	Global.lastWin=-1
	Global.winTimes=0
	get_tree().change_scene_to_file("res://Play_Fight.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
