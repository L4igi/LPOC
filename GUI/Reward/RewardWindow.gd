extends Node2D

var projectResolution
var rewardCardsData
var commonRewardCards = []
var uncommonRewardCards = []
var rareRewardCards = []
var player = null
var commonChance = 60
var uncommenChance = 30
var rareChance = 10
var instancedRewardCards = []
var rewardSlots = []
var rewardCardSlotScene 
var rewardChosen = false
onready var progressButton = get_node("ProgressButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	rewardCardSlotScene = preload("res://GUI/Reward/RewardCardArea.tscn")
	var file = File.new()
	file.open("res://GUI/Reward/RewardCards.json", file.READ)
	var cards = JSON.parse(file.get_as_text())
	file.close()
	rewardCardsData = cards.get_result()
	projectResolution = get_viewport().size
	player = get_node("/root/Player")
	init_reward_arrays()
	choose_reward_cards()
	place_reward_cards()
	
#reads json available reward cards and appends them to corresponding array
func init_reward_arrays():
	for card in rewardCardsData[player.actorName].get("COMMON").values():
		commonRewardCards.append(card)
	for card in rewardCardsData[player.actorName].get("UNCOMMON").values():
		uncommonRewardCards.append(card)
	for card in rewardCardsData[player.actorName].get("RARE").values():
		rareRewardCards.append(card)
		
#reward cards are chosen randomly to be displayed
func choose_reward_cards():
	var rewardCards = []
	for card in player.numRewardCards:
		var randomRewardRoll = randi() % 100
		if randomRewardRoll < rareChance: 
			rareRewardCards.shuffle()
			rewardCards.append(rareRewardCards.front())
		elif randomRewardRoll < uncommenChance: 
			uncommonRewardCards.shuffle()
			rewardCards.append(uncommonRewardCards.front())
		else: 
			commonRewardCards.shuffle()
			rewardCards.append(commonRewardCards.front())
	for card in rewardCards: 
		var instancedCard = CardManager.instance_card(card, player)
		instancedCard.setup_card(player)
		instancedRewardCards.append(instancedCard)
	print(instancedRewardCards)

#chosen reward cardes are placed on the screen
#number of rewards cards determins their position
func place_reward_cards():
	var slotsToGenerate = instancedRewardCards.size()
	for slot in slotsToGenerate: 
		var rewardCardSlot = rewardCardSlotScene.instance()
		add_child(rewardCardSlot)
		var posX = (slot)*projectResolution.x/(slotsToGenerate) + (projectResolution.x/(slotsToGenerate)/2)
		var posY = projectResolution.y/2
		rewardCardSlot.set_position(Vector2(posX, posY))
		rewardSlots.append(rewardCardSlot)
		setup_card_area(rewardCardSlot, instancedRewardCards[slot], slot)
		rewardCardSlot.add_child(instancedRewardCards[slot])
		rewardCardSlot.rewardCard = instancedRewardCards[slot]
		
func setup_card_area(rewardCardSlot, card, slotNum):
	var cardFrameSizeX = (card.cardFrame.get_sprite_frames().get_frame("default",0).get_width() * card.cardFrame.get_scale().x)/2
	var cardFrameSizeY = (card.cardFrame.get_sprite_frames().get_frame("default",0).get_height() * card.cardFrame.get_scale().y)/2
	rewardCardSlot.set_new_shape(Vector2(cardFrameSizeX, cardFrameSizeY))

#if the player chooses a reward card, it is removed and checked if another one can be chosen
#the reward card is added to the player deck
func pick_reward_card(rewardCard, rewardCardSlot):
	var rewardCardArray = [rewardCard.name]
	player.actorDeck.add_cards_to_active_deck(rewardCardArray)
	rewardSlots.erase(rewardCardSlot)
	rewardCardSlot.queue_free()
	rewardCard.queue_free()
	if player.numRewardCards - player.numRewardCardsToChoose == rewardSlots.size():
		reward_picking_done()
		
#remove all other slots, todo: play fancy animation
func reward_picking_done():
	for slot in rewardSlots:
		slot.rewardCard.queue_free()
		slot.queue_free()
	rewardSlots.clear()
	rewardChosen = true
	progressButton.change_text("CONTINUE")

