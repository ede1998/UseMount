normal_mounts = {
	-- HORDE - Orcs
	[5668] = "Horn of the Brown Wolf",
	[18796] = "Horn of the Swift Brown Wolf",
	[5665] = "Horn of the Dire Wolf",
	[18798] = "Horn of the Swift Gray Wolf",
	[1132] = "Horn of the Timber Wolf",
	[18797] = "Horn of the Swift Timber Wolf",
	[18245] = "Horn of the Black War Wolf",
	-- HORDE - Taurens
	[15290] = "Brown Kodo",
	[18794] = "Great Brown Kodo",
	[15277] = "Gray Kodo",
	[18795] = "Great Gray Kodo",
	[18793] = "Great White Kodo",
	[18247] = "Black War Kodo",
	-- HORDE - Trolls
	[8588] = "Whistle of the Emerald Raptor",
	[18788] = "Swift Blue Raptor",
	[8591] = "Whistle of the Turquoise Raptor",
	[18789] = "Swift Olive Raptor",
	[8592] = "Whistle of the Violet Raptor",
	[18790] = "Swift Orange Raptor",
	[18246] = "Whistle of the Black War Raptor",
	-- HORDE - Forsaken
	[13332] = "Blue Skeletal Horse",
	[13334] = "Green Skeletal Warhorse",
	[13333] = "Brown Skeletal Horse",
	[18791] = "Purple Skeletal Warhorse",
	[13331] = "Red Skeletal Horse",
	[18248] = "Red Skeletal Warhorse",
	-- HORDE - Others
	[19029] = "Horn of the Frostwolf Howler",
	-- ALLIANCE - Humans
	[2414] = "Pinto Bridle",
	[18778] = "Swift White Steed",
	[5656] = "Brown Horse Bridle",
	[18777] = "Swift Brown Steed",
	[5655] = "Chestnut Mare Bridle",
	[18776] = "Swift Palomino",
	[2411] = "Black Stallion Bridle",
	[18241] = "Black War Steed Bridle",
	-- ALLIANCE - Nightelfs
	[8632] = "Reins of the Spotted Frostsaber",
	[18766] = "Reins of the Swift Frostsaber",
	[8631] = "Reins of the Striped Frostsaber",
	[18767] = "Reins of the Swift Mistsaber",
	[8629] = "Reins of the Striped Nightsaber",
	[18902] = "Reins of the Swift Stormsaber",
	[18242] = "Reins of the Black War Tiger",
	-- ALLIANCE - Dwarves
	[5872] = "Brown Ram",
	[18786] = "Swift Brown Ram",
	[5864] = "Gray Ram",
	[18787] = "Swift Gray Ram",
	[5873] = "White Ram",
	[18785] = "Swift White Ram",
	[18244] = "Black War Ram",
	-- ALLIANCE - Gnomes
	[8595] = "Blue Mechanostrider",
	[18772] = "Swift Green Mechanostrider",
	[13321] = "Green Mechanostrider",
	[18773] = "Swift White Mechanostrider",
	[8563] = "Red Mechanostrider",
	[18774] = "Swift Yellow Mechanostrider",
	[13322] = "Unpainted Mechanostrider",
	[18243] = "Black Battlestrider",
	-- ALLIANCE - Others
	[19030] = "Stormpike Battle Charger",
	--[] = "Summon Warhorse",
	--[] = "Summon Charger",
	[13086] = "Reins of the Winterspring Frostsaber",
	-- NEUTRAL
	--[] = "Summon Felsteed",
	--[] = "Summon Dreadsteed",
	[13335] = "Deathcharger's Reins",
	[19872] = "Swift Razzashi Raptor",
	[19902] = "Swift Zulian Tiger",
	[21176] = "Black Qiraji Resonating Crystal",
}

aq40_mounts = {
	[21323] = "Green Qiraji Resonating Crystal",
	[21218] = "Blue Qiraji Resonating Crystal",
	[21321] = "Red Qiraji Resonating Crystal",
	[21324] = "Yellow Qiraji Resonating Crystal",
	[21176] = "Black Qiraji Resonating Crystal"
}

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
	--return zn and string.find(zn, "The Stockade");
	return zn and string.find(zn, "The Temple of Ahn'Qiraj");
end


function UpdateMacro()
	local mount
	if IsZoneAQ40() then
		mount = aq40_mount or ""
	else
		mount = normal_mount or ""
	end
	local macro = "/use "..mount;
	EditMacro("UseMount", "UseMount", "INV_Misc_QuestionMark", macro)
end

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
	CreateMacro("UseMount", "INV_Misc_QuestionMark", "/use "..(normal_mount or ""), true)
end

function GetMountInInventory(mount_list)
	for b=0,4 do
		for s=1,GetContainerNumSlots(b) do
			local n=GetContainerItemID(b,s)
			local result = mount_list[n]
			if result then
				return result
			end
		end
	end
end

local slash_command = {
	["aq40"] = function (mount) aq40_mount = mount print("Setting "..mount.." as AQ40 mount.") end,
	["normal"] = function (mount) normal_mount = mount print("Setting "..mount.." as normal mount.") end,
}

function PrintHelp()
	print("AQ40 Mount (/um aq40 <mount name>): "..(aq40_mount or "not set"))
	print("Normal Mount (/um normal <mount name>): "..(normal_mount or "not set"))
end

function RegisterSlashCommand()
	SlashCmdList_AddSlashCommand("USEMOUNT_SLASHCMD", function(parameters)
		local command, mount = string.match(parameters, "^(.-)%s+(.*)$")
		if command and mount then
			local action = slash_command[command]
			if action then
				action(mount)
				UpdateMacro()
				return
			end
		end
		PrintHelp()
	end, "usemount", "um")
end

local function OnPlayerEnteringWorld(self, event, isLogin, isReload)
	if isLogin or isReload then
		return
	end
	C_Timer.After(3, UpdateMacro)
end

local function OnAddonLoaded()
	C_Timer.After(3, function()
		RegisterSlashCommand()
		-- Our saved variables are ready at this point
		if aq40_mount == nil then -- first time?
			aq40_mount = GetMountInInventory(aq40_mounts)
			print("AQ40 Mount (/um aq40 <mount name>): "..(aq40_mount or "not set"))
		end
		if normal_mount == nil then -- first time?
			normal_mount = GetMountInInventory(normal_mounts)
			print("Normal Mount (/um normal <mount name>): "..(normal_mount or "not set"))
		end
		CreateMacroIfNotExists()
	end)
end

local function OnEvent(self, event, arg1, arg2)
	if event == "ADDON_LOADED" and arg1 == "UseMount" then
		OnAddonLoaded()
	elseif event == "PLAYER_ENTERING_WORLD" then
		OnPlayerEnteringWorld(self, event, arg1, arg2)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", OnEvent)
