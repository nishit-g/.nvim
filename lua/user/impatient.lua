-- Need to just call nothing else
local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
	return
end
