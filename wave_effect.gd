extends RichTextEffect
class_name WaveEffect

# Must match the BBCode tag you will use (e.g., [custom_wave])
const bbcode = "custom_wave"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
  # You can play with all these numbers to adjust it, but these settings were nice for me.
  var t := Time.get_ticks_msec() / 1000.0 + float(char_fx.relative_index) * 0.1
  var offset := sin(t * 6.0) * 2.0

  char_fx.offset.y += offset
  return true
