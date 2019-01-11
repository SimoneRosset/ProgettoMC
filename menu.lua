local composer = require( "composer" )
local scene = composer.newScene()
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local bestScore
if composer.getVariable( "sound" )==nil then
	composer.setVariable( "sound",true )
end

-- include Corona's "widget" library
local widget = require "widget"
local clouds = require "cloud"
local birds = require "bird"
local sound= require "sound"
local balloon = require "balloon"

local json = require( "json" )

local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local tutorial={}
local filePath2 = system.pathForFile( "tutorial.json", system.DocumentsDirectory )

local playBtn
local highBtn
local tutorialBtn
local soundBtn

local click = audio.loadSound( "click.wav" )
local tweet = audio.loadSound( "tweet.wav" )
local music = audio.loadSound ("jingle.mp3")



-- local speaker = display.newImageRect("speaker.png", 30, 30)
-- speaker.x = display.contentCenterX*1.8
-- speaker.y = display.contentCenterY-display.contentCenterY
-- if (sound==false) then
-- 	speaker.isVisible = false
-- else
-- 	speaker.alpha=0.5
-- end
-- local speakerOff = display.newImageRect("speaker-off.png", 30, 30)
-- speakerOff.x = display.contentCenterX*1.8
-- speakerOff.y = display.contentCenterY-display.contentCenterY
-- if (sound==false) then
-- 	speakerOff.alpha = 0.5
-- else
-- 	speakerOff.isVisible = false
-- end





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
	-- if (speaker.isVisible == true) then
	-- 	audio.play(click, {channel = 2})
	-- end
	-- go to game.lua scene
	physics.stop()
	audio.play(click, {channel = 2})

	audio.stop(1)
	timer.cancel(timerNewBird)
	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end

local function onTutorialBtnRelease()
	-- if (speaker.isVisible == true) then
	-- 	audio.play(click, {channel = 2})
	-- end
	audio.play(click, {channel = 2})
	audio.stop(1)

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
	audio.play(click, {channel = 2})
	physics.stop()
    	timer.cancel(timerNewBird)
    	Runtime:removeEventListener("enterFrame", enterFrame)
    	composer.removeScene( "menu")
    	composer.gotoScene( "highScores", "fade", 400 )
    	return true	-- indicates successful touch
end

local function onSoundBtnRelease(event)

	if composer.getVariable( "sound" ) then
		composer.setVariable( "sound", false )
		soundBtn:setSequence("soundOff")

		-- soundBtn.defaultFile="speakerOff.png"
	else
		audio.play(click, {channel = 2})
		composer.setVariable( "sound", true )
		soundBtn:setSequence("soundOn")


		-- soundBtn.defaultFile="speaker.png"


	end
end

local function onInfoBtnRelease(event)
	audio.play(click, {channel = 2})
	physics.stop()
    	timer.cancel(timerNewBird)
    	Runtime:removeEventListener("enterFrame", enterFrame)
    	composer.removeScene( "menu")
    	composer.gotoScene( "info", "fade", 400 )
end

-- local function onTap( event )
-- 	if (sound == true) then
-- 		audio.setVolume(0, {channel=1})
-- 		audio.setVolume(0, {channel=2})
-- 		audio.setVolume(0, {channel=3})
-- 		sound = false
-- 		speaker.isVisible = false
-- 		speakerOff.isVisible = true
-- 		speakerOff.alpha = 0.5
--
-- 	elseif (sound == false) then
-- 		audio.setVolume(0.5, {channel=1})
-- 		audio.setVolume(0.05, {channel=2})
-- 		audio.setVolume(0.1, {channel=3})
-- 		sound = true
-- 		speaker.isVisible = true
-- 		speaker.alpha = 0.5
-- 		speakerOff.isVisible = false
-- 	end
--
--
--     return true
-- end
--
-- speaker:addEventListener( "tap", onTap )
-- speakerOff:addEventListener( "tap", onTap)

function scene:create( event )
	local sceneGroup = self.view
	loadScores()
	loadTutorial()
	composer.setVariable( "record", scoresTable[1] )
	audio.play(music, {channel=1, loops=-1})

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
		label="Play",
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
		label="High Scores",
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
		label="Tutorial",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onTutorialBtnRelease	-- event listener function
	}
	tutorialBtn.x = display.contentCenterX
	tutorialBtn.y = display.contentCenterY*1.1

	soundBtn=sound.new(sceneGroup,display.contentCenterX*1.8,display.contentCenterY-display.contentCenterY)
	soundBtn.alpha=0.5

  infoBtn=display.newImageRect(sceneGroup,"info.png", 24,24)
	infoBtn.x,infoBtn.y=display.contentCenterX*0.2, display.contentCenterY-display.contentCenterY
	infoBtn.alpha=0.5


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
	audio.play(tweet, {channel=3})
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

	if composer.getVariable( "sound" ) then
		audio.play(music, {channel=1, loops=-1})
		audio.setVolume(0.05, {channel=1})
		audio.setVolume(0.1, {channel=2})
		audio.setVolume(0.1, {channel=3})
	else
		audio.setVolume(0, {channel=1})
		audio.setVolume(0, {channel=2})
		audio.setVolume(0, {channel=3})
	end

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
	soundBtn:toFront()
	infoBtn:toFront()


	elseif phase == "did" then
		if composer.getVariable("sound") then
			soundBtn.filename="speaker.png"
		else
			soundBtn.filename="speaker-off.png"
end
		timerNewBird=timer.performWithDelay( math.random(1,2)*2000, newBird )
		Runtime:addEventListener("enterFrame", enterFrame)
		soundBtn:addEventListener("tap", onSoundBtnRelease)
		infoBtn:addEventListener("tap", onInfoBtnRelease)


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
		soundBtn:removeEventListener("tap", onSoundBtnRelease)

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
	music = nil
	display.remove(speaker)
	display.remove(speakerOff)

	Runtime:removeEventListener("enterFrame", enterFrame)
	soundBtn:removeEventListener("tap", onSoundBtnRelease)


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
