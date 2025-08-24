extends CanvasLayer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):get_tree().change_scene_to_file("res://Theme.tscn")
	if Input.is_action_just_pressed("r"):
		get_tree().paused=false
		get_tree().change_scene_to_file("res://Play_Fight.tscn")
