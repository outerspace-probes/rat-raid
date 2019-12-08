extends Area2D

var moveSpeed = 160
var direction = "left"

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	move(delta)
	
func _on_EnemyType1_area_entered(area):
	
	if area.name == "PlayerLaserMissle":
		processDie()
	elif area.name == "PlayerRat":
		processDie()
	
# collision with tilemap
func _on_Enemy1_body_entered(body):
	changeDirection()
	
func changeDirection():
	if direction == "left":
		direction = "right"
	else:
		direction = "left"	

func move(delta):
		# move
	var moveAmt
	
	if direction == "left":
		moveAmt = -moveSpeed * delta
	else:
		moveAmt = moveSpeed * delta
	
	self.position.x += moveAmt
	
func processDie():
	queue_free()
