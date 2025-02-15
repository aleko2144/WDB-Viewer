class_name WDB_TextureLoader

static func loadFromBuffer(image : Image, data : PackedByteArray, width : int, height : int, texture_type : int) -> Image:
	var r : int
	var g : int
	var b : int
	var a : int
	var pixel  : int
	var offset : int = 0
		
	match texture_type:
		21: #4 bytes/pixel (lights glow txr, truck_parts_res.wdb)
			image = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)
			for j in range(height):
				for i in range(width):
					r = data.decode_u8(offset)
					g = data.decode_u8(offset + 1)
					b = data.decode_u8(offset + 2)
					a = data.decode_u8(offset + 3)
					offset += 4
					image.set_pixel(i, j, Color8(b, g, r, a))
		22: #4 bytes/pixel (advertisment_res.wdb) + шрифты
			image = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)
			for j in range(height):
				for i in range(width):
					r = data.decode_u8(offset)
					g = data.decode_u8(offset + 1)
					b = data.decode_u8(offset + 2)
					#a = data.decode_u8(offset + 3)
					a = 255 - data.decode_u8(offset + 3)
					offset += 4
					image.set_pixel(i, j, Color8(b, g, r, a))
		23: #2 bytes/pixel (road asphalt с полосами texture)
			#код из Д-2
			image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
			for j in range(height):
				for i in range(width):
					pixel = data.decode_u16(offset)
					r = 8 * (pixel & 0x1F)
					g = (pixel >> 3) & 0xFC
					b = (pixel >> 8) & 0xF8
					offset += 2
					image.set_pixel(i, j, Color8(b, g, r))
		26: #2 bytes/pixel (асфальт с разметкой, шрифт дорожных знаков)
			#код из Д-2
			image = Image.create_empty(width, height, false, Image.FORMAT_RGBA4444)
			for j in range(height):
				for i in range(width):
					pixel = data.decode_u16(offset)
					r = 0x10 * (pixel & 0xF)
					g = pixel & 0xF0
					b = (pixel >> 4) & 0xF0
					a = (pixel >> 8) & 0xF0
					offset += 2
					image.set_pixel(i, j, Color8(b, g, r, a))
				
	return image
