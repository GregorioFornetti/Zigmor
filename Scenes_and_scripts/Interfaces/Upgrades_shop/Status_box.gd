extends Control


func _on_Status_box_mouse_entered():
	$CanvasLayer/Tooltip.visible = true

func _on_Status_box_mouse_exited():
	$CanvasLayer/Tooltip.visible = false
