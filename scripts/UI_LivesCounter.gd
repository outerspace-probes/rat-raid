extends Node2D

onready var LifeLabel = get_node("LifesCounterLabel")

func _ready():
	
	var _conn = GameState.connect("lifes_changed",self,"_on_GameState_lifes_changed")
	LifeLabel.text = str(GameState.getLifesNum())

func _on_GameState_lifes_changed():
	
	LifeLabel.text = str(GameState.getLifesNum())
