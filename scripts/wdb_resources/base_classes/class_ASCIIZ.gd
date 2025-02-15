class_name WDB_ASCIIZ #extends Node

static func LoadFromBuffer(BinFile : StreamPeerBuffer) -> String:
	var str_array : PackedByteArray

	while (true):
		var temp_byte : int = BinFile.get_8()
		str_array.append(temp_byte)
		if !temp_byte:
			break
		
	var result : String = str_array.get_string_from_utf8()
	return result

static func ApplyName(new_name : String, default_name : String) -> String:
	if !new_name:
		return default_name
	return new_name
