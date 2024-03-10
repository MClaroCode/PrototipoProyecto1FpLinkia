extends Control

@onready var mainMenuScene = preload("res://menus/MainMenu.tscn")
@onready var mainMenuInstance = mainMenuScene.instantiate() 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(mainMenuInstance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
