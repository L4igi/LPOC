extends TextureButton
var parentcardNode = null
onready var deckListCardButton = get_node(".")
onready var cardArtRect = get_node("CardArtRect")
onready var cardComboModeRect = get_node("ComboModeRect")
onready var defenseRect = get_node("DefenseRect")
onready var defenseLabel = get_node("DefenseRect/DefenseLabel")
onready var attackRect = get_node("AttackRect")
onready var attackLabel = get_node("AttackRect/AttackLabel")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup_button(card):
	parentcardNode = card
	deckListCardButton.set_normal_texture(card.cardFrame.get_sprite_frames().get_frame("default",0))
	cardArtRect.set_texture(card.cardArt.get_sprite_frames().get_frame("default",0))
	cardComboModeRect.set_texture(card.cardComboSprite.get_texture())
	defenseRect.set_texture(card.cardFrame.get_node("CardDefense").get_texture())
	defenseLabel.set_bbcode(card.cardFrame.get_node("CardDefense/CardDefenseText").get_bbcode())
	attackRect.set_texture(card.cardFrame.get_node("CardAttack").get_texture())
	attackLabel.set_bbcode(card.cardFrame.get_node("CardAttack/CardAttackText").get_bbcode())
#
#	deckListCardButton.


func _on_DeckListCardButton_button_down():
	print(str(parentcardNode) + " pressed")
