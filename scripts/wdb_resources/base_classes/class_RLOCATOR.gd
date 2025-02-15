class_name WDB_RLOCATOR

#строка на 64 байта? обычно "*" или пустая
static func LoadFromBuffer(BinFile : StreamPeerBuffer) -> String:
	var str_array : PackedByteArray = []

	for i in range(64):
		var temp_byte : int = BinFile.get_8()
		str_array.append(temp_byte)
	
	var result : String = str_array.get_string_from_utf8()
	return result
