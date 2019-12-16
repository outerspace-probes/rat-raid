extends Node

export var healthDecreaseSpeed = 30
export var playerLifes = 4

var playerHealth = 100
var scorePoints = 0
var allowNextShoot = true
var lifesLeft
var isActiveRun = false
var playerSpawnPos = Vector2(990,0)
export var checkpointReached = 0

onready var main_scene = preload("res://MainScene.tscn")

signal score_changed
signal lifes_changed
signal fuel_empty

func _ready():
	
	lifesLeft = playerLifes
	allowNextShoot = true

func _process(delta):
	
	if isActiveRun:
		decreasePlayerHealth(delta)
		if playerHealth < 0:
			emit_signal("fuel_empty")

func getPlayerSpawnPos():
	
	return playerSpawnPos

func processPlayerDie():
	
	if playerLifes > 0:
		playerLifes -= 1
		emit_signal("lifes_changed")
		restartFromCheckpoint()
	else:
		restartGame()
		
func restartFromCheckpoint():
		
	reloadMainScene()

func restartGame():
	# reinit state
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
	
	return playerLifes	
	
func decreasePlayerHealth(delta):
	
	if playerHealth > -1:
		playerHealth -= healthDecreaseSpeed * delta / 10
	
func getPlayerHealth():
	
	return playerHealth