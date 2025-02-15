class_name WDB_Vertex

var x : float
var y : float
var z : float
var w : float

var blend : float
var bindex : int

var nx : float
var ny : float
var nz : float

var psize : float
var color_diffuse : Color
var color_specular : Color

var UV : Array

#face normal?
var fnx : float
var fny : float
var fnz : float

func LoadColorFromBuffer(target : Color, file : StreamPeerBuffer):
	target.r = file.get_u8() / 255.0
	target.g = file.get_u8() / 255.0
	target.b = file.get_u8() / 255.0
	target.a = file.get_u8() / 255.0
	
	#color = [0.0, 0.0, 0.0, 0.0]
	#return (file.get_8() / 255.0, file.get_8() / 255.0, file.get_8() / 255.0, file.get_8() / 255.0)

func LoadFromBuffer(file : StreamPeerBuffer, v_flags : WDB_VertexFlags) -> void:
	x = file.get_float()
	y = file.get_float()
	z = file.get_float()
	
	if (v_flags.flag_vertex == 2):
		#XYZ
		pass
	elif (v_flags.flag_vertex == 4):
		#XYZ W
		w = file.get_float()
	elif (v_flags.flag_vertex == 6):
		#XYZ blend
		blend = file.get_float()
		
	if (v_flags.flag_bindex):
		bindex = file.get_32()
	
	if (v_flags.flag_normals):
		nx = file.get_float()
		ny = file.get_float()
		nz = file.get_float()
		
	if (v_flags.flag_psize):
		psize = file.get_float()
				
	if (v_flags.flag_diffuse):
		LoadColorFromBuffer(color_diffuse, file)
	
	if (v_flags.flag_specular):
		LoadColorFromBuffer(color_specular, file)
	
	if (v_flags.flag_uv):
		UV.append(file.get_float())
		UV.append(file.get_float())

	for u in range(v_flags.flag_uv_cnt):
		file.seek(file.get_position() + 4)

	if (v_flags.flag_fn):
		fnx = file.get_float()
		fny = file.get_float()
		fnz = file.get_float()
