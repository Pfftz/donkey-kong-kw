extends Node2D

func _ready():
	$Body.play("matching")

func _process(delta):
	#randomizes speech bubble
	$Timer.wait_time = randi_range(1, 10)

	#idle animation
	if Global.is_bomb_moving == true:
		$Body.play("idle")
		$SpeechBubble.visible = true
	#matching animation
	if Global.is_bomb_moving == false:
		$Body.play("matching")
		$SpeechBubble.visible = false

func _on_timer_timeout():
	var random_speech = randi() % 3
	match random_speech:
		0:
			$SpeechBubble.play("boom")
		1:
			$SpeechBubble.play("loser")
		2:
			$SpeechBubble.play("swearing")
