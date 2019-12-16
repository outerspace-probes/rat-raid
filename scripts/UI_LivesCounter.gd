extends Node2D

onready var LifeLabel = get_node("LifesCounterLabel")
onready var GameOverLabel = get_node("GameOverLabel")

func _ready():
	
	var _conn = GameState.connect("lifes_changed",self,"_on_GameState_lifes_changed")
	var _conn2 = GameState.connect("game_over",self,"_on_GameState_game_over")
	LifeLabel.text = str(GameState.getLifesNum())

func _on_GameState_lifes_changed():
	
	LifeLabel.text = str(GameState.getLifesNum())

func _on_GameState_game_over():
	
	LifeLabel.hide()
	GameOverLabel.show()