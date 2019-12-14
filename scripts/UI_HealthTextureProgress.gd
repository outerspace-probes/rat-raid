extends TextureProgress

func _ready():
	
	self.value = GameState.getPlayerHealth()
	
func _process(_delta):
	
	self.value = GameState.getPlayerHealth()
