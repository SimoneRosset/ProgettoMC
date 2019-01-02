-- Definizione del modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y )

	if not parent then error( "ERROR: Expected display object" ) end

	-- Crea la scena ed i suoni
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	-- Carica lo spritesheet 
	local sheetData = { width = 50, height = 50, numFrames = 9, sheetContentWidth = 450, sheetContentHeight = 50 }
	local sheet = graphics.newImageSheet( "balloonSheet.png", sheetData )
	local sequenceData = {
		{ name = "balloon", frames = { 1 } , time = 300, loopCount = 0 },
		{ name = "boom", frames = { 1,2,3,4,5,6,7,8,9 } , time = 300, loopCount = 1 },
	}
	balloon = display.newSprite( parent, sheet, sequenceData )
	balloon.x, balloon.y, balloon.width,balloon.height  = x, y, 50, 50

	balloon:setSequence("balloon")
	balloon:play()

	-- Restituisce l'istanza "balloon"
	balloon.name = "balloon"
	balloon.type = "balloon"
	return balloon
end

return M
