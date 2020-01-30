extends Node

# state vars

export var healthDecreaseSpeed = 50
var playerLifes = 3
export var checkpointReached = 0

var playerHealth = 100
var scorePoints = 0
var allowNextShoot = true
var lifesLeft
var isActiveRun = false
var isGameOver = false
var isLowFuel = false
var playerSpawnPos = Vector2(990,0)
var godMode = false

# initial state backup
var initSpawnPos = playerSpawnPos

onready var main_scene = preload("res://MainScene.tscn")
onready var LowFuelAudio = $LowFuelAudioStreamPlayer

signal score_changed
signal lifes_changed
signal fuel_empty
signal game_over
signal checkpoint_destroyed

func _ready():
	
	lifesLeft = playerLifes
	allowNextShoot = true
	
func _process(delta):
	
	if isActiveRun:
		if !godMode:
			decreasePlayerHealth(delta)
		if playerHealth < 0:
			emit_signal("fuel_empty")
		
		if playerHealth > 30:
			isLowFuel = false
		else:
			isLowFuel = true
	
	if isLowFuel && !LowFuelAudio.playing:
		LowFuelAudio.play()
	elif !isLowFuel:
		LowFuelAudio.stop()

func _input(event):
	
	if isGameOver:
		if event.is_action_pressed("FIRE") || event.is_action_pressed("MOVE_LEFT") || event.is_action_pressed("MOVE_RIGHT") || event.is_action_pressed("ACCELERATE") || event.is_action_pressed("BREAK"):
			isGameOver = false
			restartGame()
			
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_F12:
			restartGame()
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_F11:
			godMode = !godMode
			print("godmode switch")
			
func getPlayerSpawnPos():
	
	return playerSpawnPos

func processPlayerDie():
	
	LowFuelAudio.stop()
	
	if lifesLeft > 0:
		lifesLeft -= 1
		emit_signal("lifes_changed")
		restartFromCheckpoint()
	else:
		isGameOver = true
		emit_signal("game_over")
		
func restartFromCheckpoint():
		
	reloadMainScene()

func restartGame(var savePoints = false):
	# reinit state
	if !savePoints:
		scorePoints = 0
	checkpointReached = 0
	lifesLeft = playerLifes
	playerSpawnPos = initSpawnPos
	isLowFuel = false
	godMode = false
	reloadMainScene()

func reloadMainScene():
	
	LowFuelAudio.stop()
	call_deferred("deferredReload")
	
func deferredReload():
	
	isActiveRun = false
	playerHealth = 100
	get_tree().get_root().find_node("GameWorld",true,false).queue_free()
	var _rel = get_tree().change_scene_to(main_scene)
	LowFuelAudio.stop()
	isLowFuel = false
	
func checkpointHit(checkpointObj):

	checkpointReached += 1
	playerSpawnPos = checkpointObj.position
	emit_signal("checkpoint_destroyed")
	checkpointObj.destroy()
	
func playerRefuel(fuelAmt):
	
	if playerHealth < 100:
		playerHealth += fuelAmt

func addScorePoints(points):
	
	scorePoints += points
	emit_signal("score_changed")
	
func getScorePoints():
	
	return scorePoints	

func getLifesNum():
	
	return lifesLeft	
	
func decreasePlayerHealth(delta):
	
	if playerHealth > -1:
		playerHealth -= healthDecreaseSpeed * delta / 10
	
func getPlayerHealth():
	
	return playerHealth
	
func stopLowFuelAudio():
	
	LowFuelAudio.stop()