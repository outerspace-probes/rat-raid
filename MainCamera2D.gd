extends Camera2D

var playerNode

func _ready():
	playerNode = get_tree().get_root().find_node("PlayerRatArea2D", true, false)
	self.position = playerNode.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = playerNode.position