class_name LogSystem

var str_AppVersion : String = "v 0.2 03.02.25" #"v 0.1 17.02.24"
var str_RootDir : String = "."

static func getDateFormated() -> String:
	var str_day : String
	var int_day : int = Time.get_datetime_dict_from_system()["day"]
	var str_month : String
	var int_month : int = Time.get_datetime_dict_from_system()["month"]
	var str_year : String = str(Time.get_datetime_dict_from_system()["year"])
	
	str_day = str(int_day) if int_day >= 10 else '0%s' % int_day
	str_month = str(int_month) if int_month >= 10 else '0%s' % int_month
	
	return '%s.%s.%s' % [str_day, str_month, str_year]
	
static func getTimeFormated() -> String:
	var str_hour : String
	var int_hour : int = Time.get_datetime_dict_from_system()["hour"]
	var str_minute : String
	var int_minute : int = Time.get_datetime_dict_from_system()["minute"]
	var str_second : String
	var int_second : int = Time.get_datetime_dict_from_system()["second"]
	
	str_hour = str(int_hour) if int_hour >= 10 else '0%s' % int_hour
	str_minute = str(int_minute) if int_minute >= 10 else '0%s' % int_minute
	str_second = str(int_second) if int_second >= 10 else '0%s' % int_second
	
	return '%s:%s:%s' % [str_hour, str_minute, str_second]

static func writeToOutputLog(text) -> void:
	writeToLog(text, './viewer_output.log')
	
static func writeToErrorLog(text) -> void:
	writeToLog(text, './viewer_error.log')
	
static func writeToErrorLogNoPrint(text) -> void:
	writeToLog_no_print(text, './viewer_error.log')
	
static func writeOutputLogHeader() -> void:
	#'\t v. %s [%s %s]'
	writeToLog('\t %s [%s %s]' % ["v 0.3 11.02.25", getDateFormated(), getTimeFormated()], 'viewer_output.log')
	writeToLog('------------------------------------------------------', 'viewer_output.log')
	writeToLog('WDB Viewer started', './viewer_output.log')
	writeToLog('vk.com/rnr_mods\n', './viewer_output.log')
	
static func writeErrorLogHeader() -> void:
	#'\t v. %s [%s %s]'
	writeToLog('\t %s [%s %s]' % ["v 0.3 11.02.25", getDateFormated(), getTimeFormated()], 'viewer_error.log')
	writeToLog('-Import errors:----------------------------------------\n', 'viewer_error.log')

static func writeToLog(text, file_name) -> void:
	print(text)
	#file_name = profiles_dir + profile_name + '/' + file_name
	#file_name = str_RootDir + file_name

	if (FileAccess.file_exists(file_name)):
		var Log : FileAccess = FileAccess.open(file_name, FileAccess.READ_WRITE)
		Log.seek_end()
		Log.store_line(text)
		Log.close()
	else:
		var Log : FileAccess = FileAccess.open(file_name, FileAccess.WRITE)
		Log.store_line(text)
		Log.close()
		
static func writeToLog_no_print(text, file_name) -> void:
	if (FileAccess.file_exists(file_name)):
		var Log : FileAccess = FileAccess.open(file_name, FileAccess.READ_WRITE)
		Log.seek_end()
		Log.store_line(text)
		Log.close()
	else:
		var Log : FileAccess = FileAccess.open(file_name, FileAccess.WRITE)
		Log.store_line(text)
		Log.close()
	
func writeErrorLog(header, text, file_name) -> void:
	#'\t v. %s [%s %s]'
	writeToLog('\t %s [%s %s]' % [str_AppVersion, getDateFormated(), getTimeFormated()], file_name)
	writeToLog(header, file_name)
	writeToLog(text + "\n", file_name)
	
static func writeDateToLog(file_name) -> void:
	writeToLog('\t [%s %s]' % [getDateFormated(), getTimeFormated()], file_name)
	
func writeErrorLogAndExit(header, text, file_name) -> void:
	#get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED
	#get_window().borderless = (false)
	writeErrorLog(header, text, file_name)
	breakpoint
