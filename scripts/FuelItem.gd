extends Area2D

export var rewardPoints = 358

func _ready():
	
	add_to_group("fuel")


func _on_FuelItem_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.addScorePoints(rewardPoints)
		queue_free()
