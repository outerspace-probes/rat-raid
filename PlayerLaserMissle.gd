extends Area2D

export var missleSpeed = 1200

var playerNode
var bridgeNode
var isOnBridge = false

func _ready():
	
	playerNode = get_tree().get_root().find_node("PlayerRat", true, false)
	bridgeNode = get_tree().get_root().find_node("RouteBridgesTileMap", true, false)
	
	self.position.x = playerNode.position.x	
	set_process(true)	
	isOnBridge = overlaps_body(bridgeNode)
	add_to_group("playermissles")
	
	# detect exit screen and destroy object
	yield(get_node("VisibilityNotifier2D"), "screen_exited")
	queue_free()

func _process(delta):
	self.position.x = playerNode.position.x
	self.position.y -= missleSpeed * delta
	
func _on_PlayerLaserMissle_area_entered(area):
	if area.is_in_group("enemies"):
		destroy()

func _on_PlayerLaserMissle_body_entered(body):
	
	if body.name == "RouteBridgesTileMap":
		isOnBridge = true

func _on_PlayerLaserMissle_body_exited(body):
	
	if body.name == "RouteBridgesTileMap":
		isOnBridge = false
		
func destroy():
	queue_free()