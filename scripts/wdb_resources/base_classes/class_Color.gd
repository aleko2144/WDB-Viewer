class_name WDB_Color

static func LoadFromBuffer(file : StreamPeerBuffer) -> Color:
	var result : Color
	result = Color8(file.get_u8(), file.get_u8(), file.get_u8(), file.get_u8())
	return result
