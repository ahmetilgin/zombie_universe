extends CanvasLayer


var bar_red = preload("res://oyun sprite/healthbar/decrease.png")
var bar_green = preload("res://oyun sprite/healthbar/health.png")
var bar_yellow = preload("res://oyun sprite/healthbar/back.png")

func update_powerbar(value):
    $Player_Health.texture_progress = bar_green
    if value > 40:
           $Player_Health.texture_progress = bar_yellow
    if value > 70:
            $Player_Health.texture_progress = bar_red
    $Player_Health.value = value