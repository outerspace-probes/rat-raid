extends Area2D

export var rewardPoints = 358

const exploPrefab = preload("res://prefabs/ExplosionFuel.tscn")
onready var GameWorld = get_node("/root/GameWorld")
onready var AudioExplo = $FuelExploAudioStreamPlayer
onready var PlayerRat = $"/root/GameWorld/PlayerRat"

func _ready():
	
	add_to_group("fuel")

func _on_FuelItem_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.addScorePoints(rewardPoints)
		
		var explo = exploPrefab.instance()
		explo.set_position(get_global_transform().get_origin())
		GameWorld.add_child(explo)	
		
		AudioExplo.play()
		$Sprite.hide()
		$CollisionShape2D.queue_free()
		
		var timer = Timer.new()
		timer.connect("timeout", self, "queue_free")
		timer.set_wait_time(2)
		timer.start()
		
func isFueling():
	
	return overlaps_area(PlayerRat)