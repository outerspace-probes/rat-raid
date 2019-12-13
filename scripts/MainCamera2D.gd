extends Camera2D

var playerNode

func _ready():
	playerNode = get_tree().get_root().find_node("PlayerRat", true, false)
	self.position.x = playerNode.position.x
	self.position.y = playerNode.position.y - 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position.y = playerNode.position.y - 300