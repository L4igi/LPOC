extends AnimatedSprite
onready var cardFrameAnimationPlayer = $CardFrameAnimationPlayer
onready var tween = $Tween
var initPosition = self.position
var bounceHeight = Vector2(0,-15)

func play_card_animation(animationToPlay):
	cardFrameAnimationPlayer.play(animationToPlay)
	
func play_card_animation_funcref(animationToPlay, funcRef, paramArray):
	cardFrameAnimationPlayer.play(animationToPlay)
	yield(get_tree().create_timer(cardFrameAnimationPlayer.get_current_animation_length()),"timeout")
	funcRef.call_funcv(paramArray)
	
	
func bounce_card(bounce, targetPosition = null):
	if !targetPosition:
		targetPosition = bounceHeight
	if bounce:
		tween.interpolate_property(self, "position",
				position, initPosition + targetPosition, 0.3,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(self, "position",
				position, initPosition, 0.3,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func bounce_card_target_funcRef(targetPosition, funcRef, paramArray):
	tween.interpolate_property(self, "position",
			position, initPosition + targetPosition, 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(self, "position",
			position, initPosition, 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	funcRef.call_funcv(paramArray)
	
