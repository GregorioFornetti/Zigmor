extends Control


func _on_Status_box_mouse_entered():
	$Tooltip.visible = true

func _on_Status_box_mouse_exited():
	$Tooltip.visible = false
