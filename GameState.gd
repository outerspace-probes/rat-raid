extends Node

export var healthDecreaseSpeed = 15

var playerHealth = 100
var playerLives = 4
var scorePoints = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	decreasePlayerHealth(delta)
	
func decreasePlayerHealth(delta):
	
	playerHealth -= healthDecreaseSpeed * delta / 10
	
func getPlayerHealth():
	
	return playerHealth