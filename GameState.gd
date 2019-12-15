extends Node

export var healthDecreaseSpeed = 35
export var playerLifes = 4

export var playerHealth = 100
var scorePoints = 0
var allowNextShoot = true
var lifesLeft
var checkpointReached = 0

signal score_changed

func _ready():
	
	lifesLeft = playerLifes
	allowNextShoot = true

func _process(delta):
	
	decreasePlayerHealth(delta)

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