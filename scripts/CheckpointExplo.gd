extends Node2D

func _ready():

	var timer = Timer.new()
	timer.connect("timeout",self,"_on_explo_timeout")
	timer.set_wait_time(3)
	add_child(timer)
	timer.start()
	
func _on_explo_timeout():
	
	queue_free()	