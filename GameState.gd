extends Node

export var healthDecreaseSpeed = 35
export var playerLifes = 4

var playerHealth = 100
var scorePoints = 0
var allowNextShoot = true
var lifesLeft
var checkpointReached = 0

onready var main_scene = preload("res://MainScene.tscn")

signal score_changed

func _ready():
	
	lifesLeft = playerLifes
	allowNextShoot = true

func _process(delta):
	
	decreasePlayerHealth(delta)

func processPlayerDie():
	
	if playerLifes > 0:
		restartFromCheckpoint()
	else:
		restartGame()
		
func restartFromCheckpoint():
	# checkpoint pos			
	reloadMainScene()

func restartGame():
	# reinit state
	reloadMainScene()

func reloadMainScene():
	
	call_deferred("deferredReload")
	
func deferredReload():
	
	get_tree().get_root().find_node("PlayerLaserMissles",true,false).free()
	get_tree().get_root().find_node("GameWorld",true,false).free()
	var _rel = get_tree().change_scene_to(main_scene)

func checkpointHit():

	checkpointReached += 1
	print("checkpoint hit " + str(checkpointReached))

func playerRefuel(fuelAmt):
	
	playerHealth += fuelAmt

func addScorePoints(points):
	
	scorePoints += points
	emit_signal("score_changed")
	
func getScorePoints():
	
	return scorePoints	
	
func decreasePlayerHealth(delta):
	
	if playerHealth > -1:
		playerHealth -= healthDecreaseSpeed * delta / 10
	
func getPlayerHealth():
	
	return playerHealth