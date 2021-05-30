extends Position2D

var rewardCardArea 
var rewardCardShape
var rewardCard
var rewardScene 

# Called when the node enters the scene tree for the first time.
func _ready():
	rewardScene = get_parent()
	rewardCardArea = get_node("RewardCardArea")
	rewardCardShape = get_node("RewardCardArea/RewardCardShape")

func set_new_shape(newShape):
	rewardCardShape.get_shape().set_extents(newShape)

func _on_RewardCardArea_mouse_entered():
	rewardCard.cardFrame.bounce_card(true)

func _on_RewardCardArea_mouse_exited():
	rewardCard.cardFrame.bounce_card(false)


func _on_RewardCardArea_input_event(viewport, event, shape_idx):
	if (event.is_action_pressed("mouseClickLeft")):
		rewardScene.pick_reward_card(rewardCard, self)
