local M = {}
local composer = require( "composer" )

function M.new( parent, x, y )
	if not parent then error( "ERROR: Expected display object" ) end

	-- Get scene and sounds
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	-- Load spritesheet
	local sheetData = { width = 150, height = 100, numFrames = 15, sheetContentWidth = 750, sheetContentHeight = 300 }
	local sheet = graphics.newImageSheet( "cloudSheet.png", sheetData )
	local sequenceData = {
		{ name = "type1", frames = { 1}  },
		{ name = "type2", frames = { 2 }  },
		{ name = "type3", frames = { 3 }  },
		{ name = "type4", frames = { 4 }  },
		{ name = "type5", frames = { 5 }  },
		{ name = "type6", frames = { 6 }  },
		{ name = "type7", frames = { 7 }  },
		{ name = "type8", frames = { 8} },
		{ name = "type9", frames = { 9 }  },
		{ name = "type10", frames = { 10} },
		{ name = "type11", frames = { 11 }  },
		{ name = "type12", frames = { 12 }  },
		{ name = "type13", frames = { 13 }  },
		{ name = "type14", frames = { 14 } },
		{ name = "type15", frames = { 15 }  },
	}
	cloud = display.newSprite( parent, sheet, sequenceData )
	cloud.x, cloud.y, cloud.width,cloud.height  = x, y, 150, 100
	cloudTypes = { "type1", "type2","type3","type4", "type5","type6","type7", "type2","type8","type9", "type10","type11","type12", "type13","type14","type15"  }
	cloud:setSequence(cloudTypes[math.random(#cloudTypes)])
	cloud:play()
	cloud.name = "cloud"
	cloud.type = "cloud"
	return cloud
end

return M
