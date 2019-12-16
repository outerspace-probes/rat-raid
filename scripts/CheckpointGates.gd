extends Node

func _ready():

	if GameState.checkpointReached > 0:
		var checkpoints = get_children()
		checkpoints[GameState.checkpointReached - 1].queue_free()
