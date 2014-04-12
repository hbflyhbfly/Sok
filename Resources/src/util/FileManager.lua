local log = require "src/util/log"
require "src/util/json"

local fileUtils = CCFileUtils:sharedFileUtils()

local FileManager = {}
	function FileManager:readJsonFileToTable(file)
		local _fileName = file
		local _fileData = {}
		local _tableData = {}
		if nil == _fileName or "" == _fileName then
			log:Error("File'name doesn't exist")
			return nil
		end

		_fileData = fileUtils:getFileData("res/data/".._fileName,"r",0)
		if not _fileData then

			log:Error("Data obtained failure")
			return nil
		end

		local _tableData = json.decode(_fileData) --json->table数据

		return _tableData
	end
return FileManager
