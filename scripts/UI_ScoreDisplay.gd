extends Node2D

onready var GameState = get_tree().get_root().find_node("GameState", true, false)
onready var ScoreLabel = get_node("ScoreDisplayLabel")

func _ready():
	
	ScoreLabel.text = str(GameState.getScorePoints())

#func _process(delta):
#	pass

func _on_GameState_score_changed():
	
	ScoreLabel.text = str(GameState.getScorePoints())
