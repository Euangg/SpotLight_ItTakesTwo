extends GPUParticles2D

var timer:float=0
func _ready() -> void:
	emitting=true

func _process(delta: float) -> void:
	timer+=delta
	modulate.a=1-(timer-0.2)/0.8

func _on_finished() -> void:
	queue_free()
