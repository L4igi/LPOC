extends Control

onready var player = get_node("/root/Player")
onready var deckListButtons = preload("res://GUI/Options/DeckListMenu/DeckListCardButton.tscn")
var deckList 

func update_deckList(deckList):
	var cardCount = 0
	var currentHboxContainer = HBoxContainer.new()
	for card in deckList:
		if cardCount%4 == 0:
			currentHboxContainer = HBoxContainer.new()
			$ScrollContainer/VBoxContainer.add_child(currentHboxContainer)
			currentHboxContainer.add_constant_override("separation", 8)
		var cardTextureButton = deckListButtons.instance()
		currentHboxContainer.add_child(cardTextureButton)
		cardTextureButton.setup_button(card)
		cardCount += 1
