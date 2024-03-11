extends Control

@onready var editorScene = preload("res://menus/DataEditor.tscn")

@export var newGameButton : Button
@export var dataEditorButton : Button
@export var quitButton : Button


@onready var editorInstance = editorScene.instantiate() 

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_button_pressed():
	pass # Replace with function body.


func _on_data_editor_button_pressed():
	self.add_child(editorInstance)
	self.visible = false


func _on_quit_button_pressed():
	get_tree().quit()
