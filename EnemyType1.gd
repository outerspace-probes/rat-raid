extends Area2D

export var moveSpeed = 90
var direction = "left"

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# move
	var moveAmt
	
	if direction == "left":
		moveAmt = -moveSpeed * delta
	else:
		moveAmt = moveSpeed * delta
	
	self.position.x += moveAmt
	