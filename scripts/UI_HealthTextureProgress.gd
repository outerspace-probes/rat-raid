extends TextureProgress

onready var GameState = get_tree().get_root().find_node("GameState", true, false)

func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	
	self.value = GameState.getPlayerHealth()
