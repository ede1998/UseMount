normal_mount = "Swift Palomino"
aq40_mount = "Green Qiraji Resonating Crystal"

function SlashCmdList_AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func
    local command = ''
    for i = 1, select('#', ...) do
        command = select(i, ...)
        if strsub(command, 1, 1) ~= '/' then
            command = '/' .. command
        end
        _G['SLASH_'..name..i] = command
    end
end

function IsZoneAQ40()
	local zn = GetRealZoneText();
	return zn and string.find(zn, "The Temple of Ahn'Qiraj");
end

SlashCmdList_AddSlashCommand("USEMOUNT_SLASHCMD", function()
	print("slash command done")
end, "usemount", "um")

function CreateMacroIfNotExists()
	local gl, perChar = GetNumMacros()
	for i=121,121+perChar do
		local name, icon, body, isLocal = GetMacroInfo(i)
		if name and string.find(name, "UseMount") then
			return
		end
	end
	for i=1,gl do
		local name, icon, body, isLocal = GetMacroInfo(i)
		if name and string.find(name, "UseMount") then
			return
		end
	end
	CreateMacro("UseMount", "INV_Misc_QuestionMark", "/use "..normal_mount, true)
end

local function OnEvent(self, event, isLogin, isReload)
	CreateMacroIfNotExists()
	local mount
	if IsZoneAQ40() then
		mount = aq40_mount
	else
		mount = normal_mount
	end
	local macro = "/use "..mount;
	EditMacro("UseMount", "UseMount", "INV_Misc_QuestionMark", macro)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)
