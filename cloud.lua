local M = {}

local composer = require( "composer" )

function M.new( parent, x, y )

	if not parent then error( "ERROR: Expected display object" ) end

	-- Get scene and sounds
	local scene = composer.getScene( composer.getSceneName( "current" ) )
	--local sounds = scene.sounds

	-- Store map placement and hide placeholder

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
	cloud.name = "cloud"
	cloud.type = "cloud"
	return cloud
end

return M
