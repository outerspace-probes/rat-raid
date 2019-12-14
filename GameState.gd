extends Node

export var healthDecreaseSpeed = 35
export var playerLifes = 4

var playerHealth = 100
var scorePoints = 0
var allowNextShoot = true
var lifesLeft

signal score_changed

func _ready():
	
	lifesLeft = playerLifes
	allowNextShoot = true

func _process(delta):
	
	decreasePlayerHealth(delta)

func playerRefuel(fuelAmt):
	
	playerHealth += fuelAmt

func addScorePoints(points):
	
	scorePoints += points
	emit_signal("score_changed")
	
func getScorePoints():
	
	return scorePoints	
	
func decreasePlayerHealth(delta):
	
	playerHealth -= healthDecreaseSpeed * delta / 10
	
func getPlayerHealth():
	
	return playerHealth