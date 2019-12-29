extends Area2D

export var rewardPoints = 278
export var moveSpeed = 250
export var startFromLeft = false
export var disableMoving = false
export var isFlyingEnemy = false

var direction = "left"
var isWaiting = true

const exploPrefab = preload("res://prefabs/Explosion.tscn")

onready var Sprite = get_node("Sprite")
onready var GameWorld = get_node("/root/GameWorld")
onready var AudioExplo = $"/root/GameWorld/GlobalAudio/ExploAudioStreamPlayer"
#onready var viewportWidth = get_viewport().get_size().x
onready var viewportWidth = 1980

func _ready():
	
	add_to_group("enemies")
	if startFromLeft:
		direction = "right"
		Sprite.flip_h = true
		
func _process(delta):
	
	if !isWaiting && !disableMoving:
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
	
	AudioExplo.play()
	GameState.addScorePoints(rewardPoints)
	var explo = exploPrefab.instance()
	explo.set_position(self.position)
	GameWorld.add_child(explo)
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	
	if isFlyingEnemy:
		print("vp exited")
		if direction == "left":
			self.position.x = viewportWidth
		else:
			self.position.x = 0