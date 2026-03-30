class_name FloatingText extends Label3D

func set_amount(amount: int) -> void:
    text = str(amount)

func start() -> void:
    # Initial state: start big
    scale = Vector3(2.0, 2.0, 2.0)
    modulate.a = 1.0

    var tween := create_tween()
    tween.set_parallel(true)

    # Rise up (explicitly on Y axis)
    var target_y := position.y + 1.2
    tween.tween_property(self, "position:y", target_y, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

    # Scale down (big to small)
    tween.tween_property(self, "scale", Vector3(0.7, 0.7, 0.7), 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

    # Fade out
    tween.tween_property(self, "modulate:a", 0.0, 0.4).set_delay(0.2)

    tween.chain().tween_callback(queue_free)
