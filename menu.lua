local composer = require( "composer" )
local scene = composer.newScene()
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local bestScore
-- include Corona's "widget" library
local widget = require "widget"
local clouds = require "cloud"
local birds = require "bird"

local balloon = require "balloon"

local json = require( "json" )

local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local tutorial={}
local filePath2 = system.pathForFile( "tutorial.json", system.DocumentsDirectory )

local playBtn
local highBtn
local tutorialBtn

local myGlobalSoundToggle = true
local speaker = display.newImageRect("speaker.png", 30, 30)
speaker.x = display.contentCenterX*1.9
speaker.y = display.contentCenterY*1.6
local speakerOff = display.newImageRect("speaker-off.png", 30, 30)
speakerOff.x = display.contentCenterX*1.9
speakerOff.y = display.contentCenterY*1.6
speakerOff.isVisible = false

local function loadSounds()
	click = audio.loadSound( "click.wav" )
	tweet = audio.loadSound( "tweet.wav" )
	music =audio.loadSound ("PeacefulScene.wav")
	audio.reserveChannels( 2 )
	audio.setMaxVolume( 0.2, {channel=2})
end


local function loadScores()
    	local file = io.open( filePath, "r" )
	if file then
        	local contents = file:read( "*a" )
        	io.close( file )
        	scoresTable = json.decode( contents )
	end
	
	if ( scoresTable == nil or #scoresTable == 0 ) then
        	scoresTable = { 0, 0, 0}
    	end
end

	
local function loadTutorial()
	local file = io.open( filePath2, "r" )

	if file then
		local contents = file:read( "*a" )
	    	io.close( file )
	    	tutorial = json.decode( contents )
	end

	if ( tutorial == nil or #tutorial == 0) then 
		tutorial = {true}
	end
end
	

local function saveTutorial()
	table.remove( tutorial )
	local file = io.open( filePath2, "w" )

	if file then
		file:write( json.encode( tutorial ) )
		io.close( file )
	end
end
--------------------------------------------

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	audio.play(click)
	-- go to game.lua scene
	physics.stop()
	timer.cancel(timerNewBird)
	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end

local function onTutorialBtnRelease()
	audio.play(click)

	-- go to game.lua scene
	physics.stop()
    	loadTutorial()
    	table.insert( tutorial, 1, true )
    	saveTutorial()
    	timer.cancel(timerNewBird)
    	Runtime:removeEventListener("enterFrame", enterFrame)
    	composer.removeScene( "menu")
    	composer.gotoScene( "game", "fade", 400 )
    	return true	-- indicates successful touch
end

local function onHighBtnRelease()
	audio.play(click)

	-- go to game.lua scene
	physics.stop()
    	timer.cancel(timerNewBird)
    	Runtime:removeEventListener("enterFrame", enterFrame)
    	composer.removeScene( "menu")
    	composer.gotoScene( "highScores", "fade", 400 )
    	return true	-- indicates successful touch
end

local function onTap( event )
	if (speaker.isVisible == true) then
		speaker.isVisible = false
		speakerOff.isVisible = true

	elseif (speaker.isVisible == false) then
		audio.stop()
		speaker.isVisible = true
		speakerOff.isVisible = false
	end
	
	myGlobalSoundToggle = speakerOff.isVisible
    	return true
end 

speaker:addEventListener( "tap", onTap )	
speakerOff:addEventListener( "tap", onTap)

function scene:create( event )
	local sceneGroup = self.view
	loadScores()
	loadTutorial()
	composer.setVariable( "record", scoresTable[1] )


	-- Called when the scene's view does not exist.

	-- display a background image
	local backgroundM = display.newImageRect( "background.png", display.actualContentWidth, display.actualContentHeight )
	backgroundM.anchorX = 0
	backgroundM.anchorY = 0
	backgroundM.x = 0 + display.screenOriginX
	backgroundM.y = 0 + display.screenOriginY
	backgroundM:setFillColor( .9 )

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 250, 60 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = display.contentCenterY*0.6
	
	grass = display.newImageRect( "ground.png", screenW, screenH)
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight*1.8 + display.screenOriginY
  	grass.alpha=0.7
	

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		textOnly=true,
		label="play",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY*0.8

	highBtn = widget.newButton{
		textOnly=true,
		label="highScore",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onHighBtnRelease	-- event listener function
	}
	highBtn.x = display.contentCenterX
	highBtn.y = display.contentCenterY*0.95

	tutorialBtn = widget.newButton{
		textOnly=true,
		label="tutorial",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onTutorialBtnRelease	-- event listener function
	}
	tutorialBtn.x = display.contentCenterX
	tutorialBtn.y = display.contentCenterY*1.1

	-- all display objects must be inserted into group
	sceneGroup:insert( backgroundM )


	sceneGroup:insert( grass )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( highBtn )
	sceneGroup:insert( tutorialBtn )
	birdgroup=display.newGroup()
	sceneGroup:insert( birdgroup )
end

local function newBird(event)
	audio.play(tweet, {channel=1})
	birds.new(birdgroup, (math.random(1,2)-1)*screenW, math.random(0,display.actualContentHeight/4)).alpha=0.8
	timerNewBird=timer.performWithDelay( math.random(1,2)*3000, newBird )
end

local function offScreen(object)
	local bounds = object.contentBounds
	local sox = display.screenOriginX
	if bounds.xMax < sox then return true end
	if bounds.xMin > display.actualContentWidth - sox then return true end
	return false
end
	
local function enterFrame(event)
	for i=1, birdgroup.numChildren do
		if birdgroup[i].sequence=="flyToRight"    then
			birdgroup[i]:setLinearVelocity(200,0)

		else
			birdgroup[i]:setLinearVelocity(-200,0)
		end
		
		if not birdgroup[i]==nil then
			if offScreen(birdgroup[i])==true then
				display.remove( birdgroup[i] )
				birdgroup:remove(birdg[i])
			end
		end
	end
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		physics.start()

		for _=1,3 do
			clouds.new(sceneGroup, math.random(display.actualContentWidth), math.random(0, display.actualContentHeight/4.5))
		end

	local balloon=balloon.new(sceneGroup, display.contentCenterX,  display.contentCenterY*1.3)
	corda=display.newImageRect( sceneGroup, "corda.png", 1,grass.y-grass.height-balloon.y)
	corda.x,corda.y=balloon.x,balloon.y+balloon.height
	corda.alpha=0.4
	balloon:toFront()
	
	elseif phase == "did" then
		timerNewBird=timer.performWithDelay( math.random(1,2)*2000, newBird )
		Runtime:addEventListener("enterFrame", enterFrame)
		audio.play(music, {channel=1, loops=-1})
	end
end


function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		timer.cancel(timerNewBird)
		physics.stop()

	elseif phase == "did" then
		-- Called when the scene is now off screen
		Runtime:removeEventListener("enterFrame", enterFrame)
		composer.removeScene("menu")
	end
end


function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	audio.dispose(click)
	click=nil
	audio.dispose(tweet)
	tweet=nil
	audio.dispose(music)
	
	Runtime:removeEventListener("enterFrame", enterFrame)

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if highBtn then
		highBtn:removeSelf()	-- widgets must be manually removed
		highBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
