extends Node

# state vars

export var healthDecreaseSpeed = 30
export var playerLifes = 4

var playerHealth = 100
var scorePoints = 0
var allowNextShoot = true
var lifesLeft
var isActiveRun = false
var isGameOver = false
var playerSpawnPos = Vector2(990,0)
export var checkpointReached = 0

# initial state backup
var initSpawnPos = playerSpawnPos

onready var main_scene = preload("res://MainScene.tscn")

signal score_changed
signal lifes_changed
signal fuel_empty
signal game_over

func _ready():
	
	lifesLeft = playerLifes
	allowNextShoot = true

func _process(delta):
	
	if isActiveRun:
		decreasePlayerHealth(delta)
		if playerHealth < 0:
			emit_signal("fuel_empty")

func _input(event):
	
	if isGameOver:
		if event.is_action_pressed("FIRE") || event.is_action_pressed("MOVE_LEFT") || event.is_action_pressed("MOVE_RIGHT") || event.is_action_pressed("ACCELERATE") || event.is_action_pressed("BREAK"):
			isGameOver = false
			restartGame()

func getPlayerSpawnPos():
	
	return playerSpawnPos

func processPlayerDie():
	
	if lifesLeft > 0:
		lifesLeft -= 1
		emit_signal("lifes_changed")
		restartFromCheckpoint()
	else:
		isGameOver = true
		emit_signal("game_over")
		
func restartFromCheckpoint():
		
	reloadMainScene()

func restartGame():
	# reinit state
	scorePoints = 0
	checkpointReached = 0
	lifesLeft = playerLifes
	playerSpawnPos = initSpawnPos
	reloadMainScene()

func reloadMainScene():
	
	call_deferred("deferredReload")
	
func deferredReload():
	
	isActiveRun = false
	playerHealth = 100
	# get_tree().get_root().find_node("PlayerLaserMissles",true,false).free()
	get_tree().get_root().find_node("GameWorld",true,false).queue_free()
	var _rel = get_tree().change_scene_to(main_scene)
	
func checkpointHit(checkpointObj):

	checkpointReached += 1
	playerSpawnPos = checkpointObj.position
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