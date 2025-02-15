class_name WDB_VertexFlags

var flag_vertex   : int
var flag_bindex   : int
var flag_normals  : int
var flag_psize    : int
var flag_diffuse  : int
var flag_specular : int
var flag_fn       : int
var flag_uv       : int
var flag_uv_cnt   : int
var int_value     : int #оригинальное значение

func FGVF2NumOfTex(vertex_flags) -> int:
	return (vertex_flags & 0xF00) >> 8

func FGVF2TexRes(vertex_flags, i) -> int:
	if (FGVF2NumOfTex(vertex_flags) < i + 1):
		return 0
	var var1 : int = (vertex_flags >> (2 * i + 16)) & 3
	if (var1 == 3):
		return 1
	else:
		return (var1 + 2)

func GetFromInt(flags : int) -> void:
	flag_vertex   = flags & 0xE
	flag_bindex   = flags & 0x1000
	flag_normals  = flags & 0x10
	flag_psize    = flags & 0x20
	flag_diffuse  = flags & 0x40
	flag_specular = flags & 0x80
	flag_fn       = flags & 0x2000
	int_value  = flags
	
	var k : int = 0
	var result : int
	while (true):
		k += 1
		result = FGVF2NumOfTex(flags)
		if (k >= result):
			break
		for j in range(FGVF2TexRes(flags, k)):
			flag_uv_cnt += 1
					
	if (FGVF2NumOfTex(flags)):
		flag_uv = 1
