extends Area2D

func _ready():
	
	add_to_group("checkpoint")

func _on_Checkpoint_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.checkpointHit(self)
		
func destroy():
	
	queue_free()