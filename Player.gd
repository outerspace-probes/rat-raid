extends Area2D

export var speedDefault = 280
export var speedLeftRight = 380

var speedCurrent = speedDefault
const laserMissle = preload("res://PlayerLaserMissle.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	# moving up
	self.position.y -= speedCurrent * delta
	# moving left-right
	if Input.is_action_pressed("MOVE_LEFT"):
		self.position.x -= speedLeftRight * delta
	if Input.is_action_pressed("MOVE_RIGHT"):
		self.position.x += speedLeftRight * delta
	
func _input(event):
	
	if event.is_action_pressed("FIRE") && event.echo == false:
		createLaser(self.position)

func createLaser(pos):
	var spawnPos = Vector2(pos.x,pos.y + 20)
	var laser = laserMissle.instance()
	laser.set_position(spawnPos)
	get_tree().get_root().add_child(laser)
	#add_child(laser)