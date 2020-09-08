function loadUI()
	ui = {
		fonts = {
			default = love.graphics.newFont('resources/fonts/VCR_OSD_MONO_1.001.ttf', 24),
		},
		bottom_panel = loveframes.Create('panel'),
		toolgrid = loveframes.Create('grid'),
		version = loveframes.Create('text'),
		resources_display = loveframes.Create('text')

	}
	ui.version:SetPos(0, 0)
	ui.version:SetText(settings.VERSION)
	ui.version:SetFont(ui.fonts.default)

	ui.resources_display:SetFont(ui.fonts.default)

	ui.toolgrid:SetRows(1)
	ui.toolgrid:SetColumns(4)

	createToolButton('roadbutton', 'resources/gfx/road_horizontal.png', 'road')
	createToolButton('housebutton', 'resources/gfx/house.png', 'house')
	createToolButton('chimneybutton', 'resources/gfx/chimney.png', 'chimney')
	createToolButton('farmbutton', 'resources/gfx/farm.png', 'farm')

	ui.toolgrid:AddItem(ui.roadbutton, 1, 1)
	ui.toolgrid:AddItem(ui.chimneybutton, 1, 2)
	ui.toolgrid:AddItem(ui.housebutton, 1, 3)
	ui.toolgrid:AddItem(ui.farmbutton, 1, 4)
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

