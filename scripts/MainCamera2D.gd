extends Camera2D

var playerNode

func _ready():
	playerNode = get_tree().get_root().find_node("PlayerRat", true, false)
	self.position.x = playerNode.position.x
	self.position.y = playerNode.position.y - 300

func _process(_delta):
	self.position.y = playerNode.position.y - 300