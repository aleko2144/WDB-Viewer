class_name WDB_Sphere

var x : float
var y : float
var z : float
var w : float

func LoadFromBuffer(BinFile : StreamPeerBuffer) -> void:
	x = BinFile.get_double()  #x
	y = BinFile.get_double()  #y
	y = BinFile.get_double()  #z
	w = BinFile.get_double()  #w
