extends Node

func _ready():

	if GameState.checkpointReached > 0:
		var checkpoints = get_children()
		GameState.playerSpawnPos = checkpoints[GameState.checkpointReached - 1].position
		checkpoints[GameState.checkpointReached - 1].queue_free()
