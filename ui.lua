function loadUI()
	ui = {
		fonts = {
			default = love.graphics.newFont('resources/fonts/VCR_OSD_MONO_1.001.ttf', 24),
		},
		bottom_panel = loveframes.Create('panel'),
		toolgrid = loveframes.Create('grid'),
		version = loveframes.Create('text'),
		resources_display = loveframes.Create('text'),
		building_info = {
			frame = loveframes.Create('frame'),
			building_image = loveframes.Create('image'),
			assigned_workers = loveframes.Create('text'),
			assign_input = loveframes.Create('numberbox')
		}
	}
	ui.building_info.building_image:SetParent(ui.building_info.frame)
	ui.building_info.assigned_workers:SetParent(ui.building_info.frame)
	ui.building_info.assign_input:SetParent(ui.building_info.frame)
	ui.building_info.frame:SetState('tile-info')
	ui.building_info.frame.OnClose = function(object)
		loveframes.SetState('none')
	end

	ui.version:SetPos(0, 0)
	ui.version:SetText(settings.VERSION)
	ui.version:SetFont(ui.fonts.default)

	ui.resources_display:SetFont(ui.fonts.default)

	ui.toolgrid:SetRows(1)
	ui.toolgrid:SetColumns(5)

	createToolButton('roadbutton', 'resources/gfx/road_horizontal.png', 'road')
	createToolButton('housebutton', 'resources/gfx/house.png', 'house')
	createToolButton('chimneybutton', 'resources/gfx/chimney.png', 'chimney')
	createToolButton('farmbutton', 'resources/gfx/farm.png', 'farm')
	createToolButton('infobutton', 'resources/gfx/info.png', 'info')

	ui.toolgrid:AddItem(ui.infobutton, 1, 1)
	ui.toolgrid:AddItem(ui.roadbutton, 1, 2)
	ui.toolgrid:AddItem(ui.chimneybutton, 1, 3)
	ui.toolgrid:AddItem(ui.housebutton, 1, 4)
	ui.toolgrid:AddItem(ui.farmbutton, 1, 5)
	ui.toolgrid:SetItemAutoSize(true)

	ui.bottom_panel:SetPos(0, love.graphics.getHeight() - 100)
	ui.resources_display:SetParent(ui.bottom_panel)
	ui.toolgrid:SetParent(ui.bottom_panel)
end

function createToolButton(name, image_path, tool_name)
	ui[name] = loveframes.Create('imagebutton')
	ui[name]:SetImage(image_path)
	ui[name]:SetText('')
	ui[name]:SizeToImage()
	ui[name].OnClick = function(object)
		current_tool = tool_name
	end
end

function showTileInfo(i, j)
	local tile = getTile(i, j)
	loveframes.SetState('tile-info')
	ui.building_info.frame:SetName(tile.type..' at '..i..', '..j)
	ui.building_info.frame:Center()
	if tile.type == 'farm' then
		showFarmInfo(i, j, tile)
	end
end


function showFarmInfo(i, j, tile)
	ui.building_info.building_image:SetImage('resources/gfx/farm.png')
	ui.building_info.assigned_workers:SetText('Assigned workers: '..tile.assigned_workers)
	ui.building_info.assign_input:SetValue(tile.assigned_workers)
	ui.building_info.assign_input.OnValueChanged = function(object, value)
		tile.assigned_workers = value
	end
end

