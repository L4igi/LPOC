extends Button

onready var labelText = get_node("Label")

func change_text(newText):
	labelText.set_text(newText)

#the scene switches to the next level and the reward window node is removed
func _on_ProgressButton_button_down():
	SceneSwitcher.goto_next_level()
	get_parent().queue_free()
