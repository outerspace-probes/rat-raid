extends Area2D

export var missleSpeed = 1700

onready var playerNode = get_tree().get_root().find_node("PlayerRat", true, false)
onready var bridgeNode = get_tree().get_root().find_node("RouteBridgesTileMap", true, false)
onready var routeNode = get_tree().get_root().find_node("RouteTileMap", true, false)

var isOnBridge = false

func _ready():
		
	self.position.x = playerNode.position.x	
	set_process(true)	
	isOnBridge = overlaps_body(bridgeNode)
	add_to_group("playermissles")
	
	# detect exit screen and destroy object
	yield(get_node("VisibilityNotifier2D"), "screen_exited")
	destroy()

func _process(delta):
	
	self.position.x = playerNode.position.x
	self.position.y -= missleSpeed * delta
	
	if overlaps_body(routeNode) && !overlaps_body(bridgeNode):
		destroy()
	
func _on_PlayerLaserMissle_area_entered(area):
	
	if area.is_in_group("enemies"):
		destroy()
	elif area.is_in_group("fuel"):
		if !area.isFueling():
			destroy()
	elif area.is_in_group("checkpoint"):
		destroy()
		
func destroy():
	GameState.allowNextShoot = true
	queue_free()