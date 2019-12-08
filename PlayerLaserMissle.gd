extends Area2D

export var missleSpeed = 900
var playerNode

func _ready():
	
	playerNode = get_tree().get_root().find_node("PlayerRat", true, false)
	self.position.x = playerNode.position.x	
	set_process(true)
	
	# detect exit screen and destroy object
	yield(get_node("VisibilityNotifier2D"), "screen_exited")
	queue_free()

func _process(delta):
	self.position.x = playerNode.position.x
	self.position.y -= missleSpeed * delta