extends Area2D

export var rewardPoints = 278
export var isFlyingEnemy = false

var moveSpeed = 250
var direction = "left"
var isWaiting = true

onready var Sprite = get_node("Sprite")

func _ready():
	add_to_group("enemies")

func _process(delta):
	
	if !isWaiting:
		move(delta)
		
func _on_EnemyOne_area_entered(area):
		
	if area.is_in_group("playermissles"):
		processDie()
	elif area.name == "PlayerRat":
		processDie()
		
	elif area.name == "LandEnemyTrigger":
		if  !isFlyingEnemy:
			isWaiting = false	
	elif area.name == "FlyingEnemyTrigger":
		if isFlyingEnemy:
			isWaiting = false
		
# collision with tilemap
func _on_EnemyOne_body_entered(body):
	if !isFlyingEnemy && body.name == "RouteTileMap":
		changeDirection()
	
func changeDirection():
	if direction == "left":
		direction = "right"
		Sprite.flip_h = true
	else:
		direction = "left"	
		Sprite.flip_h = false

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
