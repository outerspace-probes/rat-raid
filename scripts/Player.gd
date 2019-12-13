extends Area2D

export var speedDefault = 360
export var speedMin = 160
export var speedMax = 460
export var speedAccelerationBrake = 360
export var speedLeftRight = 380

var speedCurrent = speedDefault
const laserMissle = preload("res://prefabs/PlayerLaserMissle.tscn")
var bridgeNode 
var routeNode
var initPos
var isOnBridge = false
onready var AnimPlayer = get_node("RatAnimationPlayer")

func _ready():
	initPos = self.position
	bridgeNode = get_tree().get_root().find_node("RouteBridgesTileMap", true, false)
	routeNode = get_tree().get_root().find_node("RouteTileMap", true, false)
	AnimPlayer.play("RatRunStraight")
	
func _process(delta):
	
	move(delta)
			
func _input(event):
	# fire
	if event.is_action_pressed("FIRE") && event.is_echo() == false:
		createLaser(self.position)
		
	# left-right animations	
	if event.is_action_pressed("MOVE_LEFT") && event.is_echo() == false:	
		AnimPlayer.set_current_animation("RatRunLeft")
	if event.is_action_released("MOVE_LEFT"):
		AnimPlayer.set_current_animation("RatRunStraight")
		
	if event.is_action_pressed("MOVE_RIGHT") && event.is_echo() == false:	
		AnimPlayer.set_current_animation("RatRunRight")
	if event.is_action_released("MOVE_RIGHT"):
		AnimPlayer.set_current_animation("RatRunStraight")

func move(delta):
	# moving up
	self.position.y -= speedCurrent * delta
	
	# moving left-right
	if Input.is_action_pressed("MOVE_LEFT"):
		self.position.x -= speedLeftRight * delta
	if Input.is_action_pressed("MOVE_RIGHT"):
		self.position.x += speedLeftRight * delta	

func createLaser(pos):
	
	var spawnPos = Vector2(pos.x,pos.y + 20)
	var laser = laserMissle.instance()
	laser.set_position(spawnPos)
	get_tree().get_root().add_child(laser)


func _on_PlayerRat_area_entered(area):
		
	if area.is_in_group("enemies"):
		processDie()
		
func _on_PlayerRat_body_entered(body):
	
	if !isOnBridge:		
		if body.name == "RouteTileMap":
			processDie()
			
	if body.name == "RouteBridgesTileMap":
		isOnBridge = true
		
func _on_PlayerRat_body_exited(body):
	
	if body.name == "RouteBridgesTileMap":
		isOnBridge = false
		if overlaps_body(routeNode):
			processDie()
	
func processDie():
	self.position = initPos
