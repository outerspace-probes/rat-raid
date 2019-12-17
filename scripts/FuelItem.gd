extends Area2D

export var rewardPoints = 358

const exploPrefab = preload("res://prefabs/ExplosionFuel.tscn")
onready var GameWorld = get_node("/root/GameWorld")
onready var AudioExplo = $"/root/GameWorld/GlobalAudio/ExploAudioStreamPlayer"

func _ready():
	
	add_to_group("fuel")


func _on_FuelItem_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.addScorePoints(rewardPoints)
		
		var explo = exploPrefab.instance()
		explo.set_position(self.position)
		GameWorld.add_child(explo)	
		AudioExplo.play()	
		queue_free()
