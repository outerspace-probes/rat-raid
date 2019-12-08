extends Area2D

export var speedDefault = 240
export var speedLeftRight = 280
var speedCurrent = speedDefault

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	# moving up
	self.position.y -= speedCurrent * delta
	# moving left-right
	if Input.is_action_pressed("MOVE_LEFT"):
		self.position.x -= speedLeftRight * delta
	if Input.is_action_pressed("MOVE_RIGHT"):
		self.position.x += speedLeftRight * delta
	
func _input(event):
	pass
