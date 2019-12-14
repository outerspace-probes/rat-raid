extends Area2D

onready var GameState = get_tree().get_root().find_node("GameState", true, false)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group("checkpoint")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Checkpoint_area_entered(area):
	
	if area.is_in_group("playermissles"):
		
		GameState.checkpointHit()
		queue_free()