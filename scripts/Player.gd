extends Area2D

export var speedDefault = 360
export var speedMin = 220
export var speedMax = 620
export var accelerationBrake = 800
export var speedLeftRight = 380
export var refuelSpeed = 20

var speedCurrent
var bridgeNode 
var routeNode
var spawnInitPos = null
var startAnimOffset = 600
var isOnBridge = false
var isRefueling = false
var isRunStarted = false
var isWaitingForStart = false
var isDyingState = false
var isStartingAnim = true

const laserMissle = preload("res://prefabs/PlayerLaserMissle.tscn")
onready var AnimPlayer = get_node("RatAnimationPlayer")
onready var AudioLaser = $LaserAudioStreamPlayer
onready var AudioFueling = $FuelingAudioStreamPlayer
onready var AudioDie = $DieAudioStreamPlayer
onready var Collider = $CollisionPolygon2D
onready var StepSounds = $StepSounds.get_children()
onready var stepSoundCount = $StepSounds.get_child_count()

func _ready():
	
	self.hide()
	Collider.set_disabled(true)
	spawnInitPos = GameState.getPlayerSpawnPos()
	self.position = Vector2(spawnInitPos.x, spawnInitPos.y + startAnimOffset)
	speedCurrent = speedDefault
	bridgeNode = get_tree().get_root().find_node("RouteBridgesTileMap", true, false)
	routeNode = get_tree().get_root().find_node("RouteTileMap", true, false)
	AnimPlayer.stop()
	GameState.stopLowFuelAudio()
	var _conn = GameState.connect("fuel_empty",self,"_on_GameState_fuel_empty")
	
func _process(delta):
	
	if isRunStarted:
		
		move(delta)
		
		if(isRefueling):
			GameState.playerRefuel(refuelSpeed * delta)
			
	elif isStartingAnim:
		
		if self.position.y >= spawnInitPos.y:
			self.position.y -= speedDefault * delta
		else:
			isStartingAnim = false
			isWaitingForStart = true
			self.show()
			Collider.set_disabled(false)
										
func _input(event):
		
	if isRunStarted:
		# fire
		if event.is_action_pressed("FIRE") && event.is_echo() == false:
			if GameState.allowNextShoot == true:
				createLaser(self.position)
				GameState.allowNextShoot = false
			
		# left-right animations	
		if event.is_action_pressed("MOVE_LEFT") && event.is_echo() == false:	
			AnimPlayer.set_current_animation("RatRunLeft")
		if event.is_action_released("MOVE_LEFT"):
			AnimPlayer.set_current_animation("RatRunStraight")
			
		if event.is_action_pressed("MOVE_RIGHT") && event.is_echo() == false:	
			AnimPlayer.set_current_animation("RatRunRight")
		if event.is_action_released("MOVE_RIGHT"):
			AnimPlayer.set_current_animation("RatRunStraight")

	elif isWaitingForStart:
			if event.is_action_pressed("FIRE") || event.is_action_pressed("MOVE_LEFT") || event.is_action_pressed("MOVE_RIGHT") || event.is_action_pressed("ACCELERATE") || event.is_action_pressed("BREAK"):
				isRunStarted = true
				isWaitingForStart = false
				GameState.isActiveRun = true
				AnimPlayer.play("RatRunStraight")

func move(delta):
	
	# moving up
	self.position.y -= speedCurrent * delta
	
	# moving left-right
	if Input.is_action_pressed("MOVE_LEFT"):
		self.position.x -= speedLeftRight * delta
	if Input.is_action_pressed("MOVE_RIGHT"):
		self.position.x += speedLeftRight * delta	
		
	# acceleration & break
	if Input.is_action_pressed("ACCELERATE"):
		if speedCurrent <= speedMax:
			speedCurrent += accelerationBrake * delta
			setAnimSpeedScale()
	elif Input.is_action_pressed("BREAK"):
		if speedCurrent >= speedMin:
			speedCurrent -= accelerationBrake * delta
			setAnimSpeedScale()
	else:
		if speedCurrent > speedDefault:
			speedCurrent -= accelerationBrake * delta
			setAnimSpeedScale()
		elif speedCurrent < speedDefault:
			speedCurrent += accelerationBrake * delta
			setAnimSpeedScale()	

func setAnimSpeedScale():
	
	AnimPlayer.set_speed_scale((speedCurrent / speedDefault) * 0.9)
		
func createLaser(pos):
	
	var spawnPos = Vector2(pos.x,pos.y + 20)
	var laser = laserMissle.instance()
	laser.set_position(spawnPos)
	get_tree().get_root().find_node("PlayerLaserMissles",true,false).add_child(laser)
	AudioLaser.play()
	
func playStepSound():
	
	var randStepNum = int(rand_range(1,stepSoundCount))
	StepSounds[randStepNum - 1].play()

# collisions

func _on_PlayerRat_area_entered(area):
		
	if area.is_in_group("enemies"):
		if !GameState.godMode:
			processDie()
		
	if area.is_in_group("checkpoint"):
		if !GameState.godMode:
			processDie()
		
	if area.is_in_group("fuel"):
		isRefueling = true
		AudioFueling.play()

func _on_PlayerRat_area_exited(area):
	
	if area.is_in_group("fuel"):
		isRefueling = false
		AudioFueling.stop()
		
func _on_PlayerRat_body_entered(body):
	
	if !isOnBridge:		
		if body.name == "RouteTileMap":
			if !GameState.godMode:
				processDie()
			
	if body.name == "RouteBridgesTileMap":
		isOnBridge = true
		
func _on_PlayerRat_body_exited(body):
	
	if body.name == "RouteBridgesTileMap":
		isOnBridge = false
		if overlaps_body(routeNode):
			if !GameState.godMode:
				processDie()

func _on_GameState_fuel_empty():
	
	if !GameState.godMode:
		processDie()
	
func processDie():
	
	isDyingState = true
	AudioDie.play()
	
	isRunStarted = false
	isWaitingForStart = false
	isStartingAnim = false
	GameState.isActiveRun = false
	
	AnimPlayer.set_speed_scale(1)
	AnimPlayer.play("RatDying")
	
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_dying_timeout")
	timer.set_wait_time(1)
	add_child(timer)
	timer.start()
	
func _on_dying_timeout():
	
	GameState.processPlayerDie()
	hide()