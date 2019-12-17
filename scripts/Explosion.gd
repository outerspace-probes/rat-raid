extends Node2D

func _ready():
	
	get_node("Particles2D").emitting = true
	
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_explo_timeout")
	timer.set_wait_time(2)
	add_child(timer)
	timer.start()
	
func _on_explo_timeout():
	
	queue_free()	