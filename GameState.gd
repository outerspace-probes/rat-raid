extends Node

export var healthDecreaseSpeed = 40

var playerHealth = 100
var playerLives = 4
var scorePoints = 0
var allowNextShoot = true

signal score_changed

func _ready():
	
	playerLives = 4
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