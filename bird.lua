-- Module/class for platformer enemy
-- Use this as a template to build an in-game enemy

-- Define module
local M = {}

local composer = require( "composer" )

function M.new( instance )

	if not instance then error( "ERROR: Expected display object" ) end

	-- Get scene and sounds
	local scene = composer.getScene( composer.getSceneName( "current" ) )
	--local sounds = scene.sounds

	-- Store map placement and hide placeholder
	instance.isVisible = false
	local parent = instance.parent
	local x, y = instance.x, instance.y
	local width,height= instance.width, instance.height

	-- Load spritesheet
	local sheetData = { width = 700, height = 700, numFrames = 4, sheetContentWidth = 2800, sheetContentHeight = 700 }
	local sheet = graphics.newImageSheet( "birdSheet.png", sheetData )
	local sequenceData = {
		{ name = "fly", frames = { 1, 2, 3, 4 } , time = 300, loopCount = 0, loopDirection = "bounce" },
	}
	instance = display.newSprite( parent, sheet, sequenceData )
	instance.x, instance.y, instance.widht, instance.height = x, y, width, height
	instance:setSequence( "fly" )
	instance:play()

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
	-- function instance:preCollision( event )
	-- 	local other = event.other
	-- 	local y1, y2 = self.y + 50, other.y - other.height/2
	-- 	-- Also skip bumping into floating platforms
	-- 	if event.contact and ( y1 > y2 ) then
	-- 	if other.floating then
	-- 		event.contact.isEnabled = false
	-- 	else
	-- 		event.contact.friction = 0.1
	-- 	end
	-- 	end
	-- end
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
	-- instance:addEventListener( "preCollision" )

	-- Return instance
	instance.name = "bird"
	instance.type = "bird"
	return instance
end

return M
