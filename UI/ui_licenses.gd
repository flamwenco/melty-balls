extends Control


func _on_exit_button_pressed() -> void:
	SignalBus.loadMainMenu.emit()


func _on_licenses_text_meta_clicked(meta: Variant) -> void:
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at runtime.
	OS.shell_open(str(meta))
