extends Node2D

onready var ScoreLabel = get_node("ScoreDisplayLabel")

func _ready():
	
	ScoreLabel.text = str(GameState.getScorePoints())

func _on_GameState_score_changed():
	
	ScoreLabel.text = str(GameState.getScorePoints())
