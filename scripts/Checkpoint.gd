extends Area2D

export var rewardPoints = 589

const exploPrefab = preload("res://prefabs/CheckpointExplo.tscn")
onready var GameWorld = get_node("/root/GameWorld")
onready var AudioExplo = $"/root/GameWorld/GlobalAudio/ExploAudioStreamPlayer"

func _ready():
	
	add_to_group("checkpoint")

func _on_Checkpoint_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.checkpointHit(self)
		GameState.addScorePoints(rewardPoints)

	elif area.name == "PlayerRat":
		if GameState.godMode:
			GameState.checkpointHit(self)
			GameState.addScorePoints(rewardPoints)
		
func destroy():
	
	AudioExplo.play()
	var explo = exploPrefab.instance()
	explo.set_position(get_global_transform().get_origin())
	GameWorld.add_child(explo)	
	
	queue_free()