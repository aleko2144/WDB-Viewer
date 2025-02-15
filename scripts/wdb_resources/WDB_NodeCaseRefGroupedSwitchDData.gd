class_name WDB_NodeCaseRefGroupedSwitchDData extends WDB_SimpleNodeData

#wdb.dsr:
#( DWORD caseNum )	
#( GroupedSwitchCase	cases ( (ITERATED caseNum ) ) )

var caseNum : int
var cases   : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	caseNum = file.get_32()
	for i in range(caseNum):
		var case : WDB_GroupedSwitchCase = WDB_GroupedSwitchCase.new()
		case.LoadFromBuffer(file, loader)
		cases.append(case)
