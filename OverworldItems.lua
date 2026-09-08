local function OverworldItems()
	local self = {}
	self.version = "1.0"
	self.name = "Overworld Items"
	self.author = "jwunderl"
	self.description =
	"Lists item balls and hidden items with live pickup status alongside the trainer list. Supports FireRed and LeafGreen."
	self.github = "jwunderl/OverworldItems-IronmonExtension"
	self.url = string.format("https://github.com/%s", self.github)

	local ROM = {
		START = 0x08000000,
		END_EXCLUSIVE = 0x09000000,
		POINTER_SIZE = 4,
		MAP_SEARCH_END = 0x08100000,
		MAP_LOCATOR_SIZE = 16,
		MAP_TABLE_POINTER_OFFSET = 12,
		MAP_TABLE_SIGNATURE = { 0x68001880, 0x18090B89, 0x47706808 },
		MAP_LAYOUT_SIZE = 24,
		MAX_BANKS = 128,
		MAX_MAPS_PER_BANK = 256,
	}

	local MAP_HEADER = {
		SIZE = 28,
		LAYOUT_OFFSET = 0,
		EVENTS_OFFSET = 4,
		LAYOUT_ID_OFFSET = 0x12,
		REGION_ID_OFFSET = 0x14,
	}

	local MAP_EVENTS = {
		SIZE = 20,
		OBJECT_COUNT_OFFSET = 0,
		BACKGROUND_COUNT_OFFSET = 3,
		OBJECTS_OFFSET = 4,
		BACKGROUNDS_OFFSET = 16,
	}

	local OBJECT_EVENT = {
		SIZE = 24,
		X_OFFSET = 4,
		Y_OFFSET = 6,
		SCRIPT_OFFSET = 16,
		FLAG_OFFSET = 20,
	}

	local HIDDEN_ITEM = {
		SIZE = 12,
		X_OFFSET = 0,
		Y_OFFSET = 2,
		KIND_OFFSET = 5,
		ITEM_ID_OFFSET = 8,
		FLAG_INDEX_OFFSET = 10,
		ATTRIBUTES_OFFSET = 11,
		FIRST_KIND = 5,
		LAST_KIND = 7,
		UNDERFOOT_MASK = 0x80,
		FLAG_BASE = 0x3E8,
	}

	local ITEM_SCRIPT = {
		SIZE = 12,
		SET_ITEM_OPCODE_OFFSET = 0,
		ITEM_VARIABLE_OFFSET = 1,
		ITEM_ID_OFFSET = 3,
		SET_QUANTITY_OPCODE_OFFSET = 5,
		QUANTITY_VARIABLE_OFFSET = 6,
		QUANTITY_OFFSET = 8,
		CALL_OPCODE_OFFSET = 10,
		STANDARD_SCRIPT_OFFSET = 11,
		SET_OR_COPY_VAR_OPCODE = 0x1A,
		CALL_STANDARD_OPCODE = 0x09,
		ITEM_VARIABLE = 0x8000,
		QUANTITY_VARIABLE = 0x8001,
		FIND_ITEM_SCRIPT = 1,
		VARIABLE_ID_START = 0x4000,
	}

	local SAVE_DATA = {
		EWRAM_START = 0x02000000,
		EWRAM_END_EXCLUSIVE = 0x02040000,
		BITS_PER_BYTE = 8,
		PLAYER_ID_OFFSET = 0x0A,
		PLAYER_ID_SIZE = 4,
		RENEWABLE_STEPS_VAR_OFFSET = 0x46,
		HIDDEN_FLAG_FROM_RESULT_OFFSET = -16,
		HIDDEN_SUCCESS_FROM_RESULT_OFFSET = -10,
		SCRIPT_SUCCESS = 1,
		PICKUP_RANGE_TILES = 1,
	}

	local RULES = {
		FRLG_GAME_ID = 3,
		FIRST_BERRY_ID = 133,
		LAST_BERRY_ID = 175,
		FIRST_SEVII_REGION_ID = 143,
		LAST_SEVII_REGION_ID = 195,
		COINS_ITEM_ID = 0,
	}

	local MAP_IDS = {
		SS_ANNE_EXTERIOR = 118,
		SS_ANNE_KITCHEN = 170,
		UNDERGROUND_EAST_WEST = 173,
		UNDERGROUND_NORTH_SOUTH = 174,
		POKEMON_TOWER_5F = 165,
	}

	local HEALING_CIRCLE_ITEM = { MAP_ID = MAP_IDS.POKEMON_TOWER_5F, X = 11, Y = 9 }

	local UI_LAYOUT = {
		TEXT_X = 4,
		TEXT_RIGHT_PADDING = 4,
		HEADER_Y = 4,
		SUMMARY_Y = 36,
		EMPTY_LIST_Y = 76,
		ROWS_PER_PAGE = 3,
		ROW_X = 3,
		ROW_RIGHT_PADDING = 3,
		ROW_START_Y = 70,
		ROW_PITCH = 22,
		ROW_HEIGHT = 21,
		ROW_LOCATION_OFFSET_Y = 10,
		TAB_Y = 20,
		TAB_WIDTH = 62,
		TAB_HEIGHT = 12,
		LEFT_CONTROL_X = 4,
		RIGHT_CONTROL_X = 74,
		FILTER_Y = 51,
		CHECKBOX_SIZE = 7,
		CHECKBOX_CLICK_OFFSET_Y = -2,
		CHECKBOX_CLICK_WIDTH = 66,
		CHECKBOX_CLICK_HEIGHT = 11,
		DETAIL_NAME_Y = 39,
		DETAIL_MAP_Y = 52,
		DETAIL_LOCATION_Y = 65,
		DETAIL_GUIDANCE_Y = 78,
		DETAIL_STATUS_Y = 91,
		DETAIL_SPAWN_Y = 104,
		DETAIL_COLLECTED_Y = 121,
		PAGE_X = 21,
		PAGE_Y = 136,
		PAGE_WIDTH = 42,
		PAGE_HEIGHT = 10,
		PREVIOUS_PAGE_X = 4,
		NEXT_PAGE_X = 66,
		PAGE_ARROW_Y = 137,
		PAGE_ARROW_SIZE = 10,
		TRAINER_ROWS_X = 7,
		TRAINER_ROWS_Y = 40,
		TRAINER_COLUMN_GAP = 1,
		TRAINER_ROW_GAP = 5,
	}

	local GUIDANCE_ARROW = {
		CENTER_X = 10,
		CENTER_Y = 83,
		TEXT_X = 24,
		HALF_LENGTH = 5,
		HEAD_LENGTH = 4,
		HEAD_HALF_WIDTH = 3,
		SHADOW_OFFSET = 1,
	}

	local RENEWABLE_CHANCES = {
		[64] = 10,
		[65] = 10,
		[66] = 10,
		[67] = 10,
		[70] = 30,
		[71] = 30,
		[72] = 30,
		[73] = 30,
		[74] = 30,
		[75] = 30,
		[76] = 10,
		[77] = 30,
		[78] = 30,
		[79] = 30,
		[80] = 30,
		[81] = 30,
		[82] = 30,
		[83] = 10,
		[84] = 40,
		[85] = 40,
		[86] = 40,
		[87] = 10,
		[88] = 10,
		[89] = 10,
		[90] = 60,
		[91] = 40,
		[92] = 60,
		[93] = 40,
		[94] = 40,
		[95] = 40,
		[96] = 60,
		[97] = 60,
		[98] = 60,
		[99] = 40,
		[100] = 40,
		[101] = 40,
		[102] = 10,
		[103] = 30,
		[104] = 30,
		[105] = 30,
		[106] = 30,
		[107] = 100,
		[108] = 100,
		[109] = 10,
		[110] = 10,
		[153] = 30,
		[154] = 30,
		[166] = 30,
		[167] = 30,
		[168] = 30,
		[169] = 60,
		[170] = 10,
		[174] = 10,
		[175] = 30,
		[176] = 10,
		[177] = 30,
		[178] = 10,
		[179] = 10,
		[180] = 60,
		[185] = 10,
		[186] = 30,
	}

	function self.checkForUpdates()
		local versionResponsePattern = '"tag_name"%s*:%s*"v?(%d+%.%d+)"'
		local versionCheckUrl = string.format("https://api.github.com/repos/%s/releases/latest", self.github)
		local downloadUrl = string.format("%s/releases/latest", self.url)
		local compareFunc = function(current, latest)
			return current ~= latest and not Utils.isNewerVersion(current, latest)
		end
		return Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, compareFunc),
			downloadUrl
	end

	function self.downloadAndInstallUpdate()
		return TrackerAPI.updateExtension("OverworldItems", nil, { "README.md", "deploy.sh", "pull-in.sh" })
	end

	self.maps = {}
	self.collected = {}
	local indexed = false
	local runKey
	local lastMap
	local lastFlags = {}
	local watchedItems = {}
	local lastRenewableSteps

	local function isRomAddress(address, size)
		return type(address) == "number" and address >= ROM.START
			and address + (size or 1) <= ROM.END_EXCLUSIVE
	end

	local function readItemScript(address)
		if not isRomAddress(address, ITEM_SCRIPT.SIZE) then return nil end
		if Memory.readbyte(address + ITEM_SCRIPT.SET_ITEM_OPCODE_OFFSET) ~= ITEM_SCRIPT.SET_OR_COPY_VAR_OPCODE
			or Memory.readword(address + ITEM_SCRIPT.ITEM_VARIABLE_OFFSET) ~= ITEM_SCRIPT.ITEM_VARIABLE
			or Memory.readbyte(address + ITEM_SCRIPT.SET_QUANTITY_OPCODE_OFFSET) ~= ITEM_SCRIPT.SET_OR_COPY_VAR_OPCODE
			or Memory.readword(address + ITEM_SCRIPT.QUANTITY_VARIABLE_OFFSET) ~= ITEM_SCRIPT.QUANTITY_VARIABLE
			or Memory.readbyte(address + ITEM_SCRIPT.CALL_OPCODE_OFFSET) ~= ITEM_SCRIPT.CALL_STANDARD_OPCODE
			or Memory.readbyte(address + ITEM_SCRIPT.STANDARD_SCRIPT_OFFSET) ~= ITEM_SCRIPT.FIND_ITEM_SCRIPT then
			return nil
		end
		local itemId = Memory.readword(address + ITEM_SCRIPT.ITEM_ID_OFFSET)
		local quantity = Memory.readword(address + ITEM_SCRIPT.QUANTITY_OFFSET)
		if itemId == 0 or itemId >= ITEM_SCRIPT.VARIABLE_ID_START
			or quantity == 0 or quantity >= ITEM_SCRIPT.VARIABLE_ID_START then return nil end
		return itemId, quantity
	end

	local function isBerry(itemId)
		return itemId >= RULES.FIRST_BERRY_ID and itemId <= RULES.LAST_BERRY_ID
	end

	local function isExcludedLocation(mapId, kind, tileX, tileY)
		return mapId == HEALING_CIRCLE_ITEM.MAP_ID and kind == "Ball"
			and tileX == HEALING_CIRCLE_ITEM.X and tileY == HEALING_CIRCLE_ITEM.Y
	end

	local function isSeviiMap(header)
		local regionId = Memory.readbyte(header + MAP_HEADER.REGION_ID_OFFSET)
		return regionId >= RULES.FIRST_SEVII_REGION_ID and regionId <= RULES.LAST_SEVII_REGION_ID
	end

	function self.readPickupFlag(flagId)
		local flagBytes = (GameSettings.gameVarsOffset or 0) - (GameSettings.gameFlagsOffset or 0)
		if not flagId or flagId <= 0 or flagId >= flagBytes * SAVE_DATA.BITS_PER_BYTE or not Program.isValidMapLocation() then
			return nil
		end
		local saveBlock = Utils.getSaveBlock1Addr()
		if not saveBlock or saveBlock < SAVE_DATA.EWRAM_START
			or saveBlock + GameSettings.gameVarsOffset > SAVE_DATA.EWRAM_END_EXCLUSIVE then
			return nil
		end
		local value = Memory.readbyte(saveBlock + GameSettings.gameFlagsOffset + math.floor(flagId / SAVE_DATA.BITS_PER_BYTE))
		return math.floor(value / 2 ^ (flagId % SAVE_DATA.BITS_PER_BYTE)) % 2 == 1
	end

	function self.readMap(header)
		if GameSettings.game ~= RULES.FRLG_GAME_ID then return nil, "FireRed / LeafGreen only" end
		if not isRomAddress(header, MAP_HEADER.SIZE) and header ~= GameSettings.gMapHeader then
			return nil, "Map data unavailable"
		end
		if isSeviiMap(header) then return {} end
		local events = Memory.readdword(header + MAP_HEADER.EVENTS_OFFSET)
		if not isRomAddress(events, MAP_EVENTS.SIZE) then return nil, "Map events unavailable" end
		local objectCount = Memory.readbyte(events + MAP_EVENTS.OBJECT_COUNT_OFFSET)
		local backgroundCount = Memory.readbyte(events + MAP_EVENTS.BACKGROUND_COUNT_OFFSET)
		local objects = Memory.readdword(events + MAP_EVENTS.OBJECTS_OFFSET)
		local backgrounds = Memory.readdword(events + MAP_EVENTS.BACKGROUNDS_OFFSET)
		if (objectCount > 0 and not isRomAddress(objects, objectCount * OBJECT_EVENT.SIZE))
			or (backgroundCount > 0 and not isRomAddress(backgrounds, backgroundCount * HIDDEN_ITEM.SIZE)) then
			return nil, "Map events unavailable"
		end
		local items = {}
		local mapId = Memory.readword(header + MAP_HEADER.LAYOUT_ID_OFFSET)
		for index = 0, objectCount - 1 do
			local address = objects + index * OBJECT_EVENT.SIZE
			local itemId, quantity = readItemScript(Memory.readdword(address + OBJECT_EVENT.SCRIPT_OFFSET))
			local tileX, tileY = Memory.readword(address + OBJECT_EVENT.X_OFFSET), Memory.readword(address + OBJECT_EVENT.Y_OFFSET)
			if itemId and not isBerry(itemId) and not isExcludedLocation(mapId, "Ball", tileX, tileY) then
				table.insert(items, {
					kind = "Ball",
					itemId = itemId,
					quantity = quantity,
					x = tileX,
					y = tileY,
					mapId = mapId,
					eventsAddress = events,
					flagId = Memory.readword(address + OBJECT_EVENT.FLAG_OFFSET),
				})
			end
		end
		for index = 0, backgroundCount - 1 do
			local address = backgrounds + index * HIDDEN_ITEM.SIZE
			local kind = Memory.readbyte(address + HIDDEN_ITEM.KIND_OFFSET)
			local itemId = Memory.readword(address + HIDDEN_ITEM.ITEM_ID_OFFSET)
			local tileX, tileY = Memory.readword(address + HIDDEN_ITEM.X_OFFSET), Memory.readword(address + HIDDEN_ITEM.Y_OFFSET)
			local packed = Memory.readbyte(address + HIDDEN_ITEM.ATTRIBUTES_OFFSET)
			if kind >= HIDDEN_ITEM.FIRST_KIND and kind <= HIDDEN_ITEM.LAST_KIND
				and packed < HIDDEN_ITEM.UNDERFOOT_MASK and not isBerry(itemId)
				and not isExcludedLocation(mapId, "Hidden", tileX, tileY) then
				table.insert(items, {
					kind = "Hidden",
					itemId = itemId,
					quantity = packed % HIDDEN_ITEM.UNDERFOOT_MASK,
					x = tileX,
					y = tileY,
					mapId = mapId,
					eventsAddress = events,
					flagId = HIDDEN_ITEM.FLAG_BASE + Memory.readbyte(address + HIDDEN_ITEM.FLAG_INDEX_OFFSET),
					underfoot = packed >= HIDDEN_ITEM.UNDERFOOT_MASK,
					spawnChance = RENEWABLE_CHANCES[Memory.readbyte(address + HIDDEN_ITEM.FLAG_INDEX_OFFSET)],
				})
			end
		end
		return items
	end

	function self.indexMaps()
		if indexed or GameSettings.game ~= RULES.FRLG_GAME_ID then return end
		indexed = true
		local banks
		for address = ROM.START, ROM.MAP_SEARCH_END - ROM.MAP_LOCATOR_SIZE, ROM.POINTER_SIZE do
			if Memory.readdword(address) == ROM.MAP_TABLE_SIGNATURE[1]
				and Memory.readdword(address + ROM.POINTER_SIZE) == ROM.MAP_TABLE_SIGNATURE[2]
				and Memory.readdword(address + ROM.POINTER_SIZE * 2) == ROM.MAP_TABLE_SIGNATURE[3] then
				banks = Memory.readdword(address + ROM.MAP_TABLE_POINTER_OFFSET)
				break
			end
		end
		if not isRomAddress(banks, ROM.POINTER_SIZE) then return end
		local bankPointers = {}
		local bankEnd = ROM.END_EXCLUSIVE
		for index = 0, ROM.MAX_BANKS - 1 do
			local address = banks + index * ROM.POINTER_SIZE
			if address >= bankEnd then break end
			local pointer = Memory.readdword(address)
			if not isRomAddress(pointer, ROM.POINTER_SIZE) then break end
			table.insert(bankPointers, pointer)
			if pointer > banks then bankEnd = math.min(bankEnd, pointer) end
		end
		local seen = {}
		for _, bank in ipairs(bankPointers) do
			local lastAddress = bank < banks and banks or ROM.END_EXCLUSIVE
			for _, other in ipairs(bankPointers) do
				if other > bank then lastAddress = math.min(lastAddress, other) end
			end
			for index = 0, ROM.MAX_MAPS_PER_BANK - 1 do
				if bank + index * ROM.POINTER_SIZE >= lastAddress then break end
				local header = Memory.readdword(bank + index * ROM.POINTER_SIZE)
				if not isRomAddress(header, MAP_HEADER.SIZE) then break end
				local layout = Memory.readdword(header + MAP_HEADER.LAYOUT_OFFSET)
				local mapId = Memory.readword(header + MAP_HEADER.LAYOUT_ID_OFFSET)
				if not isRomAddress(layout, ROM.MAP_LAYOUT_SIZE) or mapId == 0 then break end
				if not seen[header] then
					seen[header] = true
					self.maps[mapId] = self.maps[mapId] or {}
					table.insert(self.maps[mapId], header)
				end
			end
		end
	end

	function self.getRouteInfo(mapId)
		if mapId == MAP_IDS.SS_ANNE_KITCHEN then
			return {
				name = "S.S. Anne Kitchen", area = (RouteData.Info[MAP_IDS.SS_ANNE_EXTERIOR] or {}).area,
				trainerRouteId = MAP_IDS.SS_ANNE_EXTERIOR,
			}
		elseif mapId == MAP_IDS.UNDERGROUND_EAST_WEST then
			return { name = "Underground Path E/W" }
		elseif mapId == MAP_IDS.UNDERGROUND_NORTH_SOUTH then
			return { name = "Underground Path N/S" }
		end
		return RouteData.Info[mapId] or { name = "Map " .. tostring(mapId) }
	end

	function self.getItems(mapId, wholeArea)
		if GameSettings.gMapHeader and Program.isValidMapLocation() and mapId == TrackerAPI.getMapId()
			and isSeviiMap(GameSettings.gMapHeader) then
			return {}, 0
		end
		self.indexMaps()
		local route = self.getRouteInfo(mapId)
		local mapIds = {}
		local hasKitchen = false
		for _, subMapId in ipairs((wholeArea and route.area) or { mapId }) do
			table.insert(mapIds, subMapId)
			if subMapId == MAP_IDS.SS_ANNE_KITCHEN then hasKitchen = true end
		end
		local shipArea = (RouteData.Info[MAP_IDS.SS_ANNE_EXTERIOR] or {}).area
		if wholeArea and shipArea and route.area == shipArea and not hasKitchen then
			table.insert(mapIds, MAP_IDS.SS_ANNE_KITCHEN)
		end
		local items, unavailable, seen = {}, 0, {}
		for _, subMapId in ipairs(mapIds) do
			local headers = self.maps[subMapId]
			if not headers and Program.isValidMapLocation() and TrackerAPI.getMapId() == subMapId then
				headers = { GameSettings.gMapHeader }
			end
			if not headers then unavailable = unavailable + 1 end
			for _, header in ipairs(headers or {}) do
				local mapItems = self.readMap(header)
				if not mapItems then unavailable = unavailable + 1 end
				for _, item in ipairs(mapItems or {}) do
					local key = string.format("%s:%s:%s:%s:%s", subMapId, item.kind, item.x, item.y, item.flagId)
					if not seen[key] then
						seen[key] = true
						table.insert(items, item)
					end
				end
			end
		end
		return items, unavailable
	end

	local function saveCollected()
		local flags = {}
		for flagId in pairs(self.collected) do table.insert(flags, flagId) end
		table.sort(flags)
		TrackerAPI.saveExtensionSetting("OverworldItems", "CollectedFlags", table.concat(flags, ","))
		TrackerAPI.saveExtensionSetting("OverworldItems", "RunKey", runKey)
	end

	function self.syncRun()
		if GameSettings.game ~= RULES.FRLG_GAME_ID or not Program.isValidMapLocation() then return false end
		local saveBlock = Utils.getSaveBlock2Addr()
		if not saveBlock or saveBlock < SAVE_DATA.EWRAM_START
			or saveBlock + SAVE_DATA.PLAYER_ID_OFFSET + SAVE_DATA.PLAYER_ID_SIZE > SAVE_DATA.EWRAM_END_EXCLUSIVE then
			return false
		end
		local nextKey = string.format("%s:%s", GameSettings.getRomHash(), Memory.readdword(saveBlock + SAVE_DATA.PLAYER_ID_OFFSET))
		if runKey ~= nextKey then
			runKey = nextKey
			self.collected = {}
			lastMap, lastFlags, watchedItems = nil, {}, {}
			self.maps, indexed = {}, false
			if TrackerAPI.getExtensionSetting("OverworldItems", "RunKey") == runKey then
				local saved = tostring(TrackerAPI.getExtensionSetting("OverworldItems", "CollectedFlags") or "")
				for flag in saved:gmatch("%d+") do self.collected[tonumber(flag)] = true end
			end
		end
		return true
	end

	function self.setCollected(item, collected)
		if not item.spawnChance or not self.syncRun() then return end
		self.collected[item.flagId] = collected or nil
		saveCollected()
	end

	function self.isCollected(item)
		if item.spawnChance then return self.collected[item.flagId] == true end
		return self.readPickupFlag(item.flagId)
	end

	function self.afterEachFrame()
		self.updateGuidance()
		if GameSettings.game ~= RULES.FRLG_GAME_ID or not Program.isValidMapLocation() then
			lastMap, lastFlags, watchedItems = nil, {}, {}
			return
		end
		if not runKey then return end
		local mapId = TrackerAPI.getMapId()
		local events = Memory.readdword(GameSettings.gMapHeader + MAP_HEADER.EVENTS_OFFSET)
		if lastMap ~= events then
			lastMap, lastFlags, watchedItems = events, {}, {}
			for _, item in ipairs(self.readMap(GameSettings.gMapHeader) or {}) do
				if item.spawnChance then table.insert(watchedItems, item) end
			end
		end
		if #watchedItems == 0 then return end
		local player = Program.getPlayerMapTile()
		local renewableSteps = Memory.readword(Utils.getSaveBlock1Addr() + GameSettings.gameVarsOffset + SAVE_DATA.RENEWABLE_STEPS_VAR_OFFSET)
		for _, item in ipairs(watchedItems) do
			local flag = self.readPickupFlag(item.flagId)
			local distance = math.abs(player.x - item.x) + math.abs(player.y - item.y)
			local scriptFlag = Memory.readword(GameSettings.gSpecialVar_Result + SAVE_DATA.HIDDEN_FLAG_FROM_RESULT_OFFSET)
			local scriptSuccess = Memory.readword(GameSettings.gSpecialVar_Result + SAVE_DATA.HIDDEN_SUCCESS_FROM_RESULT_OFFSET)
			if mapId == item.mapId and flag == true and lastFlags[item.flagId] == false
				and renewableSteps == lastRenewableSteps and scriptSuccess == SAVE_DATA.SCRIPT_SUCCESS
				and distance <= SAVE_DATA.PICKUP_RANGE_TILES and scriptFlag == item.flagId and not self.collected[item.flagId] then
				self.collected[item.flagId] = true
				saveCollected()
			end
			lastFlags[item.flagId] = flag
		end
		lastRenewableSteps = renewableSteps
	end

	local screen = { Buttons = {}, rows = {}, page = 1, wholeArea = true, missingOnly = false }
	self.Screen = screen
	local originalBuild
	local wrappedBuild
	local itemTab
	local trainerTab
	local lastGuidance

	function self.getSelectedGuidance()
		local item = screen.selected
		if Program.currentScreen ~= screen or not item or not Program.isValidMapLocation()
			or GameSettings.game ~= RULES.FRLG_GAME_ID or not GameSettings.gMapHeader then
			return nil
		end
		local header = GameSettings.gMapHeader
		if isSeviiMap(header) or item.mapId ~= Memory.readword(header + MAP_HEADER.LAYOUT_ID_OFFSET)
			or item.eventsAddress ~= Memory.readdword(header + MAP_HEADER.EVENTS_OFFSET) then
			return nil
		end
		local player = Program.getPlayerMapTile()
		local deltaX, deltaY = item.x - player.x, item.y - player.y
		local vertical = deltaY < 0 and "N" or (deltaY > 0 and "S" or "")
		local horizontal = deltaX < 0 and "W" or (deltaX > 0 and "E" or "")
		return {
			deltaX = deltaX, deltaY = deltaY,
			distance = math.abs(deltaX) + math.abs(deltaY),
			direction = vertical .. horizontal,
		}
	end

	function self.updateGuidance()
		local guidance = self.getSelectedGuidance()
		local changed = (guidance == nil) ~= (lastGuidance == nil)
		if guidance and lastGuidance then
			changed = guidance.deltaX ~= lastGuidance.deltaX or guidance.deltaY ~= lastGuidance.deltaY
		end
		lastGuidance = guidance
		if changed and Program.currentScreen == screen then Program.redraw(true) end
	end

	local function drawGuidanceArrow(guidance, centerX, centerY, color, shadow)
		local length = math.sqrt(guidance.deltaX ^ 2 + guidance.deltaY ^ 2)
		local unitX, unitY = guidance.deltaX / length, guidance.deltaY / length
		local tipX, tipY = centerX + unitX * GUIDANCE_ARROW.HALF_LENGTH, centerY + unitY * GUIDANCE_ARROW.HALF_LENGTH
		local baseX, baseY = tipX - unitX * GUIDANCE_ARROW.HEAD_LENGTH, tipY - unitY * GUIDANCE_ARROW.HEAD_LENGTH
		local lines = {
			{ centerX - unitX * GUIDANCE_ARROW.HALF_LENGTH, centerY - unitY * GUIDANCE_ARROW.HALF_LENGTH, tipX, tipY },
			{ baseX - unitY * GUIDANCE_ARROW.HEAD_HALF_WIDTH, baseY + unitX * GUIDANCE_ARROW.HEAD_HALF_WIDTH, tipX, tipY },
			{ baseX + unitY * GUIDANCE_ARROW.HEAD_HALF_WIDTH, baseY - unitX * GUIDANCE_ARROW.HEAD_HALF_WIDTH, tipX, tipY },
		}
		for _, line in ipairs(lines) do
			for index = 1, #line do line[index] = math.floor(line[index] + 0.5) end
			if Theme.DRAW_TEXT_SHADOWS then
				gui.drawLine(line[1] + GUIDANCE_ARROW.SHADOW_OFFSET, line[2] + GUIDANCE_ARROW.SHADOW_OFFSET,
					line[3] + GUIDANCE_ARROW.SHADOW_OFFSET, line[4] + GUIDANCE_ARROW.SHADOW_OFFSET, shadow)
			end
			gui.drawLine(line[1], line[2], line[3], line[4], color)
		end
	end

	local function itemName(item)
		if not self.isCollected(item) then return item.kind .. " item" end
		if item.itemId == RULES.COINS_ITEM_ID then return string.format("Coins x%s", item.quantity) end
		local name = TrackerAPI.getItemName(item.itemId)
		if not name or name == "" then name = "Item #" .. item.itemId end
		if item.quantity > 1 then name = name .. " x" .. item.quantity end
		return name
	end

	function screen.refreshButtons()
		if not screen.mapId then return end
		local previousRun = runKey
		if not self.syncRun() then
			screen.items, screen.rows, screen.message = {}, {}, "No active game"
			screen.selected, screen.page, screen.totalPages = nil, 1, 1
			return
		end
		if previousRun ~= runKey then screen.selected, screen.page = nil, 1 end
		screen.items, screen.unavailable = self.getItems(screen.mapId, screen.wholeArea)
		screen.rows = {}
		screen.done, screen.unknown = 0, 0
		for _, item in ipairs(screen.items) do
			local collected = self.isCollected(item)
			if collected then screen.done = screen.done + 1 end
			if collected == nil then screen.unknown = screen.unknown + 1 end
			if not screen.missingOnly or not collected then table.insert(screen.rows, item) end
		end
		screen.totalPages = math.max(1, math.ceil(#screen.rows / UI_LAYOUT.ROWS_PER_PAGE))
		screen.page = math.min(screen.page, screen.totalPages)
		if screen.unavailable > 0 then
			screen.message = string.format("%s map(s) unreadable", screen.unavailable)
		elseif #screen.items == 0 then
			screen.message = "No field items"
		elseif screen.unknown > 0 then
			screen.message = "Pickup status unavailable"
		elseif screen.done == #screen.items then
			screen.message = "All legal items collected"
		else
			screen.message = string.format("%s/%s collected; %s left", screen.done, #screen.items,
				#screen.items - screen.done)
		end
	end

	function self.open(mapId)
		if GameSettings.game ~= RULES.FRLG_GAME_ID then
			print("Overworld Items supports FireRed and LeafGreen only.")
			return
		end
		screen.mapId = mapId or TrackerAPI.getMapId()
		screen.followMap = screen.mapId == TrackerAPI.getMapId()
		screen.page, screen.selected = 1, nil
		Program.changeScreenView(screen)
	end

	function screen.checkInput(mouseX, mouseY)
		Input.checkButtonsClicked(mouseX, mouseY, screen.Buttons)
	end

	function screen.drawScreen()
		Drawing.drawBackgroundAndMargins()
		local startX = Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN
		local startY = Constants.SCREEN.MARGIN
		local width = Constants.SCREEN.RIGHT_GAP - Constants.SCREEN.MARGIN * 2
		local colors = Theme.COLORS
		local shadow = Utils.calcShadowColor(colors["Upper box background"])
		gui.defaultTextBackground(colors["Upper box background"])
		gui.drawRectangle(startX, startY, width, Constants.SCREEN.HEIGHT - startY * 2,
			colors["Upper box border"], colors["Upper box background"])
		local function text(value, offsetY, color)
			Drawing.drawText(startX + UI_LAYOUT.TEXT_X, startY + offsetY,
				Utils.shortenText(value, width - UI_LAYOUT.TEXT_X - UI_LAYOUT.TEXT_RIGHT_PADDING, true),
				colors[color or "Default text"], shadow)
		end
		local route = self.getRouteInfo(screen.mapId)
		local title = (screen.wholeArea and route.area and route.area.name) or route.name or "Items"
		text(title, UI_LAYOUT.HEADER_Y, "Intermediate text")
		if screen.selected then
			local item = screen.selected
			text(itemName(item), UI_LAYOUT.DETAIL_NAME_Y, "Intermediate text")
			text(self.getRouteInfo(item.mapId).name, UI_LAYOUT.DETAIL_MAP_Y)
			text(string.format("%s (%s,%s)", item.kind, item.x, item.y), UI_LAYOUT.DETAIL_LOCATION_Y)
			local guidance = self.getSelectedGuidance()
			if guidance and guidance.distance > 0 then
				drawGuidanceArrow(guidance, startX + GUIDANCE_ARROW.CENTER_X, startY + GUIDANCE_ARROW.CENTER_Y,
					colors["Intermediate text"], shadow)
				local distanceText = string.format("%s %d %s", guidance.direction, guidance.distance,
					guidance.distance == 1 and "tile" or "tiles")
				Drawing.drawText(startX + GUIDANCE_ARROW.TEXT_X, startY + UI_LAYOUT.DETAIL_GUIDANCE_Y,
					Utils.shortenText(distanceText, width - GUIDANCE_ARROW.TEXT_X - UI_LAYOUT.TEXT_RIGHT_PADDING, true),
					colors["Intermediate text"], shadow)
			elseif guidance then
				text("At item tile", UI_LAYOUT.DETAIL_GUIDANCE_Y, "Positive text")
			else
				text("Direction unavailable", UI_LAYOUT.DETAIL_GUIDANCE_Y, "Intermediate text")
			end
			if item.spawnChance then
				text(string.format("%s%% spawn; one pickup", item.spawnChance), UI_LAYOUT.DETAIL_STATUS_Y)
				local present = self.readPickupFlag(item.flagId)
				text(present == false and "Spawned now" or "Not spawned now", UI_LAYOUT.DETAIL_SPAWN_Y)
			else
				local collected = self.isCollected(item)
				text(collected == nil and "Unknown status" or (collected and "Collected" or "Not collected"), UI_LAYOUT.DETAIL_STATUS_Y)
			end
		else
			text(screen.message or "No active game", UI_LAYOUT.SUMMARY_Y, "Intermediate text")
			for rowIndex = 1, UI_LAYOUT.ROWS_PER_PAGE do
				local item = screen.rows[(screen.page - 1) * UI_LAYOUT.ROWS_PER_PAGE + rowIndex]
				if item then
					local offsetY = UI_LAYOUT.ROW_START_Y + (rowIndex - 1) * UI_LAYOUT.ROW_PITCH
					local collected = self.isCollected(item)
					local mark = collected == nil and "[?]" or (collected and "[x]" or "[ ]")
					text(mark .. " " .. itemName(item), offsetY, collected and "Positive text" or "Default text")
					local mapName = self.getRouteInfo(item.mapId).name
					if route.area and route.area.name then
						local prefix = route.area.name .. " "
						if mapName:sub(1, #prefix) == prefix then mapName = mapName:sub(#prefix + 1) end
					end
					local location = string.format("%s (%s,%s)", mapName, item.x, item.y)
					if item.spawnChance then location = string.format("%s%% %s", item.spawnChance, location) end
					text(location, offsetY + UI_LAYOUT.ROW_LOCATION_OFFSET_Y, "Intermediate text")
				end
			end
			if #screen.rows == 0 and #(screen.items or {}) > 0 then text("No missing items", UI_LAYOUT.EMPTY_LIST_Y) end
		end
		for _, button in pairs(screen.Buttons) do
			if button.updateSelf then button:updateSelf() end
			Drawing.drawButton(button, shadow)
		end
	end

	function self.startup()
		if originalBuild or GameSettings.game ~= RULES.FRLG_GAME_ID then return end
		local startX = Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN
		local startY = Constants.SCREEN.MARGIN
		local width = Constants.SCREEN.RIGHT_GAP - Constants.SCREEN.MARGIN * 2
		local function tab(label, offsetX, onClick)
			return {
				type = Constants.ButtonTypes.NO_BORDER,
				text = label,
				textColor = "Default text",
				box = { startX + offsetX, startY + UI_LAYOUT.TAB_Y, UI_LAYOUT.TAB_WIDTH, UI_LAYOUT.TAB_HEIGHT },
				onClick = onClick,
			}
		end
		local function showTrainers()
			local mapId = screen.mapId or TrackerAPI.getMapId()
			local route = self.getRouteInfo(mapId)
			if TrainersOnRouteScreen.buildScreen(route.trainerRouteId or mapId) then
				Program.changeScreenView(TrainersOnRouteScreen)
			else
				Program.changeScreenView(TrackerScreen)
			end
		end
		trainerTab = tab("Trainers", UI_LAYOUT.LEFT_CONTROL_X, function() end)
		trainerTab.textColor = "Intermediate text"
		itemTab = tab("Items", UI_LAYOUT.RIGHT_CONTROL_X, function() self.open(TrainersOnRouteScreen.Data.routeId) end)
		TrainersOnRouteScreen.Buttons.OverworldItemsTrainers = trainerTab
		TrainersOnRouteScreen.Buttons.OverworldItemsItems = itemTab
		screen.Buttons.Trainers = tab("Trainers", UI_LAYOUT.LEFT_CONTROL_X, showTrainers)
		screen.Buttons.Items = tab("Items", UI_LAYOUT.RIGHT_CONTROL_X, function()
			screen.selected = nil
			screen.refreshButtons()
			Program.redraw(true)
		end)
		screen.Buttons.Items.textColor = "Intermediate text"
		local function checkbox(label, offsetX, offsetY, checked, onClick, visible)
			return {
				type = Constants.ButtonTypes.CHECKBOX,
				text = label,
				textColor = "Default text",
				box = { startX + offsetX, startY + offsetY, UI_LAYOUT.CHECKBOX_SIZE, UI_LAYOUT.CHECKBOX_SIZE },
				clickableArea = {
					startX + offsetX, startY + offsetY + UI_LAYOUT.CHECKBOX_CLICK_OFFSET_Y,
					UI_LAYOUT.CHECKBOX_CLICK_WIDTH, UI_LAYOUT.CHECKBOX_CLICK_HEIGHT,
				},
				isVisible = visible or function() return screen.selected == nil end,
				updateSelf = function(button) button.toggleState = checked() end,
				onClick = function(button)
					onClick()
					button.toggleState = checked()
					screen.page = 1
					screen.refreshButtons()
					Program.redraw(true)
				end,
				toggleState = checked(),
			}
		end
		screen.Buttons.Area = checkbox("Area", UI_LAYOUT.LEFT_CONTROL_X, UI_LAYOUT.FILTER_Y, function() return screen.wholeArea end,
			function() screen.wholeArea = not screen.wholeArea end)
		screen.Buttons.Missing = checkbox("Missing", UI_LAYOUT.RIGHT_CONTROL_X, UI_LAYOUT.FILTER_Y, function() return screen.missingOnly end,
			function() screen.missingOnly = not screen.missingOnly end)
		screen.Buttons.Collected = checkbox("Collected this run", UI_LAYOUT.LEFT_CONTROL_X, UI_LAYOUT.DETAIL_COLLECTED_Y,
			function() return screen.selected ~= nil and self.isCollected(screen.selected) end,
			function() self.setCollected(screen.selected, not self.isCollected(screen.selected)) end,
			function() return screen.selected ~= nil and screen.selected.spawnChance ~= nil end)
		screen.Buttons.Collected.clickableArea[3] = width - UI_LAYOUT.LEFT_CONTROL_X - UI_LAYOUT.TEXT_RIGHT_PADDING
		for rowIndex = 1, UI_LAYOUT.ROWS_PER_PAGE do
			local slot = rowIndex
			screen.Buttons["Row" .. slot] = {
				type = Constants.ButtonTypes.NO_BORDER,
				box = {
					startX + UI_LAYOUT.ROW_X, startY + UI_LAYOUT.ROW_START_Y + (slot - 1) * UI_LAYOUT.ROW_PITCH,
					width - UI_LAYOUT.ROW_X - UI_LAYOUT.ROW_RIGHT_PADDING, UI_LAYOUT.ROW_HEIGHT,
				},
				isVisible = function() return not screen.selected and screen.rows[(screen.page - 1) * UI_LAYOUT.ROWS_PER_PAGE + slot] ~= nil end,
				onClick = function()
					screen.selected = screen.rows[(screen.page - 1) * UI_LAYOUT.ROWS_PER_PAGE + slot]
					screen.Buttons.Collected.toggleState = self.isCollected(screen.selected)
					Program.redraw(true)
				end,
			}
		end
		for _, direction in ipairs({ -1, 1 }) do
			local step = direction
			screen.Buttons[step == -1 and "Previous" or "Next"] = {
				type = Constants.ButtonTypes.PIXELIMAGE,
				image = step == -1 and Constants.PixelImages.LEFT_ARROW or Constants.PixelImages.RIGHT_ARROW,
				box = {
					startX + (step == -1 and UI_LAYOUT.PREVIOUS_PAGE_X or UI_LAYOUT.NEXT_PAGE_X),
					startY + UI_LAYOUT.PAGE_ARROW_Y, UI_LAYOUT.PAGE_ARROW_SIZE, UI_LAYOUT.PAGE_ARROW_SIZE,
				},
				isVisible = function() return not screen.selected and (screen.totalPages or 1) > 1 end,
				onClick = function()
					screen.page = (screen.page - 1 + step) % screen.totalPages + 1
					Program.redraw(true)
				end,
			}
		end
		screen.Buttons.Page = {
			type = Constants.ButtonTypes.NO_BORDER,
			box = { startX + UI_LAYOUT.PAGE_X, startY + UI_LAYOUT.PAGE_Y, UI_LAYOUT.PAGE_WIDTH, UI_LAYOUT.PAGE_HEIGHT },
			getText = function() return string.format("%s/%s", screen.page, screen.totalPages or 1) end,
			isVisible = function() return not screen.selected end,
		}
		screen.Buttons.Back = Drawing.createUIElementBackButton(function()
			if screen.selected then
				screen.selected = nil
				screen.refreshButtons()
				Program.redraw(true)
			else
				showTrainers()
			end
		end)
		originalBuild = TrainersOnRouteScreen.buildScreen
		wrappedBuild = function(mapId)
			local success = originalBuild(mapId)
			if success then
				TrainersOnRouteScreen.Pager:realignButtonsToGrid(startX + UI_LAYOUT.TRAINER_ROWS_X, startY + UI_LAYOUT.TRAINER_ROWS_Y,
					UI_LAYOUT.TRAINER_COLUMN_GAP, UI_LAYOUT.TRAINER_ROW_GAP)
				for _, row in ipairs(TrainersOnRouteScreen.Pager.Buttons) do
					for _, button in ipairs(row.buttonList or {}) do
						if button.alignToBox then button:alignToBox(row.box) end
					end
				end
			end
			return success
		end
		TrainersOnRouteScreen.buildScreen = wrappedBuild
		if TrainersOnRouteScreen.Data.routeId then wrappedBuild(TrainersOnRouteScreen.Data.routeId) end
		self.syncRun()
	end

	function self.afterProgramDataUpdate()
		if Program.currentScreen ~= screen then
			self.syncRun()
			return
		end
		if screen.followMap and Program.isValidMapLocation() and screen.mapId ~= TrackerAPI.getMapId() then
			screen.mapId, screen.selected, screen.page = TrackerAPI.getMapId(), nil, 1
		end
		screen.refreshButtons()
	end

	function self.configureOptions()
		self.open(TrackerAPI.getMapId())
	end

	function self.unload()
		if not originalBuild then return end
		if TrainersOnRouteScreen.buildScreen == wrappedBuild then TrainersOnRouteScreen.buildScreen = originalBuild end
		if TrainersOnRouteScreen.Buttons.OverworldItemsItems == itemTab then
			TrainersOnRouteScreen.Buttons.OverworldItemsItems = nil
		end
		if TrainersOnRouteScreen.Buttons.OverworldItemsTrainers == trainerTab then
			TrainersOnRouteScreen.Buttons.OverworldItemsTrainers = nil
		end
		if TrainersOnRouteScreen.Data.routeId then TrainersOnRouteScreen.buildScreen(TrainersOnRouteScreen.Data.routeId) end
		if Program.currentScreen == screen then Program.changeScreenView(TrainersOnRouteScreen) end
		originalBuild, wrappedBuild = nil, nil
	end

	return self
end
return OverworldItems
