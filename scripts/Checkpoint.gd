extends Area2D

const exploPrefab = preload("res://prefabs/CheckpointExplo.tscn")
onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	
	add_to_group("checkpoint")

func _on_Checkpoint_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.checkpointHit(self)
		
func destroy():
	
	var explo = exploPrefab.instance()
	explo.set_position(self.position)
	GameWorld.add_child(explo)	
	
	queue_free()