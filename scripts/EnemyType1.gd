extends Area2D

export var rewardPoints = 278

var moveSpeed = 220
var direction = "left"

onready var GameState = get_tree().get_root().find_node("GameState", true, false)

func _ready():
	add_to_group("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	move(delta)
	
func _on_EnemyOne_area_entered(area):
		
	if area.is_in_group("playermissles"):
		processDie()
	elif area.name == "PlayerRat":
		processDie()
	
# collision with tilemap
func _on_EnemyOne_body_entered(body):
	if body.name == "RouteTileMap":
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
	GameState.addScorePoints(rewardPoints)
	queue_free()
