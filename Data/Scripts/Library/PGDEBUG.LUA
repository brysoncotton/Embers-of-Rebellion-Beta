function DebugEventAlert(event, params)
	message = tostring(Script) .. ": handled event " .. tostring(event)
	
	function AppendParameter(ival, parameter)
		message = message .. "\nParameter " .. tostring(ival) .. ": " .. tostring(parameter)
	end
	
	table.foreachi(params, AppendParameter)
	
	MessageBox(message)
end

function MessageBox(...)
	_MessagePopup(string.format(unpack(arg)))
end

function ScriptMessage(...)
	_ScriptMessage(string.format(unpack(arg)))
end

function DebugMessage(...)
	_ScriptMessage(string.format(unpack(arg)))
end

function OutputDebug(...)
	_OuputDebug(string.format(unpack(arg)))
end

function ScriptError(...)
	outstr = string.format(unpack(arg))
	_OuputDebug(outstr .. "\n")
	_ScriptMessage(outstr)
	outstr = DumpCallStack()
	_OuputDebug(outstr .. "\n")
	_ScriptMessage(outstr)
	ScriptExit()
end

function DebugPrintTable(unit_table)
	DebugMessage("%s -- unit table contents:", tostring(Script))
	for key, obj in pairs(unit_table) do
		DebugMessage("%s -- \t\t** unit:%s", tostring(Script), tostring(obj))
	end
end
