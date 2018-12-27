-- Module/class for platformer enemy
-- Use this as a template to build an in-game enemy

-- Define module
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y )

	if not parent then error( "ERROR: Expected display object" ) end

	-- Get scene and sounds
	local scene = composer.getScene( composer.getSceneName( "current" ) )
	--local sounds = scene.sounds
	-- Store map placement and hide placeholder

	-- Load spritesheet
	local sheetData = { width = 50, height = 50, numFrames = 8, sheetContentWidth = 400, sheetContentHeight = 50 }
	local sheet = graphics.newImageSheet( "balloonSheet.png", sheetData )
	local sequenceData = {
		{ name = "balloon", frames = { 1 } , time = 300, loopCount = 0 },
		{ name = "boom", frames = { 1,2,3,4,5,6,7,8 } , time = 300, loopCount = 1 },
	}
	balloon = display.newSprite( parent, sheet, sequenceData )
	balloon.x, balloon.y, balloon.width,balloon.height  = x, y, 50, 50

	balloon:setSequence("balloon")
	balloon:play()


	-- -- Add physics
	-- physics.addBody( instance, "dynamic", { radius = 350, density = 1, bounce = 0.1, friction =  1.0 } )
	-- instance.isFixedRotation = true
	-- instance.anchorY = 0.77
	-- instance.angularDamping = 3
	-- instance.isDead = false
	--
	-- function instance:die()
	-- 	--audio.play( sounds.sword )
	-- 	self.isFixedRotation = false
	-- 	self.isSensor = true
	-- 	self:applyLinearImpulse( 0, -2 )
	-- 	self.isDead = true
	-- end
	--

	--
	-- local max, direction, flip, timeout = 250, 5000, 0.133, 0
	-- direction = direction * ( ( instance.xScale < 0 ) and 1 or -1 )
	-- flip = flip * ( ( instance.xScale < 0 ) and 1 or -1 )
	--
	-- local function enterFrame()
	--
	-- 	-- Do this every frame
	-- 	local vx, vy = instance:getLinearVelocity()
	-- 	local dx = direction
	-- 	if instance.jumping then dx = dx / 4 end
	-- 	if ( dx < 0 and vx > -max ) or ( dx > 0 and vx < max ) then
	-- 		instance:applyForce( dx or 0, 0, instance.x, instance.y )
	-- 	end
	--
	-- 	-- Bumped
	-- 	if math.abs( vx ) < 1 then
	-- 		timeout = timeout + 1
	-- 		if timeout > 30 then
	-- 			timeout = 0
	-- 			direction, flip = -direction, -flip
	-- 		end
	-- 	end
	--
	-- 	-- Turn around
	-- 	instance.xScale = math.min( 1, math.max( instance.xScale + flip, -1 ) )
	-- end
	--
	-- function instance:finalize()
	-- 	-- On remove, cleanup instance, or call directly for non-visual
	-- 	Runtime:removeEventListener( "enterFrame", enterFrame )
	-- 	instance = nil
	-- end
	--
	-- -- Add a finalize listener (for display objects only, comment out for non-visual)
	-- instance:addEventListener( "finalize" )
	--
	-- -- Add our enterFrame listener
	-- Runtime:addEventListener( "enterFrame", enterFrame )
	--
	-- -- Add our collision listener

	-- Return instance
	balloon.name = "balloon"
	balloon.type = "balloon"
	return balloon
end

return M
