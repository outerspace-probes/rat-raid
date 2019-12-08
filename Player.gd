extends Area2D

export var speedDefault = 60

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	self.position.y -= speedDefault * delta
	
