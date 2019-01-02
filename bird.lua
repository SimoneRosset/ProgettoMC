-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )
	

	--Carica lo spritesheet
	local sheetData = { width = 50, height = 50, numFrames = 8, sheetContentWidth = 200, sheetContentHeight = 100 }
	local sheet = graphics.newImageSheet( "birdSheet.png", sheetData )
	local sequenceData = {
		{ name = "flyToRight", frames = { 1, 2, 3, 4 } , time = 300, loopCount = 0, loopDirection = "bounce" },
		{ name = "flyToLeft", frames = { 8, 7, 6, 5 } , time = 300, loopCount = 0, loopDirection = "bounce" },
	}
	bird = display.newSprite( parent, sheet, sequenceData )
	bird.x, bird.y, bird.width,bird.height  = x, y, 50, 50
	physics.addBody( bird, "dynamic", { radius = 10, density = 1, bounce = 0.1, friction =  1.0 } )
	
	-- Se l'uccello si trova sul bordo sinistro va verso destra, altrimenti verso sinistra
	if x==0 then
	bird:setSequence( "flyToRight" )

else
	bird:setSequence( "flyToLeft" )
end
	bird:play()

	--Restituisce l'istanza "bird"
	bird.name = "bird"
	bird.type = "bird"
	return bird
end

return M
