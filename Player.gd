extends Area2D

export var speedDefault = 360
export var speedLeftRight = 380

var speedCurrent = speedDefault
const laserMissle = preload("res://PlayerLaserMissle.tscn")
var bridgeNode 
var routeNode
var initPos
var isOnBridge = false

func _ready():
	initPos = self.position
	bridgeNode = get_tree().get_root().find_node("RouteBridgesTileMap", true, false)
	routeNode = get_tree().get_root().find_node("RouteTileMap", true, false)
	
func _process(delta):
	
	move(delta)
			
func _input(event):
	
	if event.is_action_pressed("FIRE") && event.echo == false:
		createLaser(self.position)

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
