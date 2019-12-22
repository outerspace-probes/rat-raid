extends Polygon2D

onready var animPlayer = $AnimationPlayer

func _ready():
	
	var _conn = GameState.connect("checkpoint_destroyed",self,"_on_GameState_checkpoint_destroyed")

func _on_GameState_checkpoint_destroyed():
	
	animPlayer.play("Flash")