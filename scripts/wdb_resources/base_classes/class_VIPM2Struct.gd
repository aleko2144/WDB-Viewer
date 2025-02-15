class_name WDB_VIPM2Struct

#wdb.dsr:
#( WORD numNewTriangles )      ; // количество треугольников включаемых в модель
#( WORD numModifications )     ; // количество модификаций
#( WORD numSwapCycles )        ; // количество циклов для перестановок
#( DWORD operationIndex )      ; // начальный индекс в Fix Face таблице 
#( float error )               ; // ошибка соответствующая данной

var numNewTriangles  : int
var numModifications : int
var numSwapCycles    : int
var operationIndex   : int
var error            : float

func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	numNewTriangles  = file.get_u16()
	numModifications = file.get_u16()
	numSwapCycles    = file.get_u16()
	operationIndex   = file.get_32()
	error            = file.get_float()
