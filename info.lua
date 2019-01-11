local composer = require( "composer" )

local scene = composer.newScene()
local widget = require "widget"
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local clouds = require "cloud"
local balloon = require "balloon"
local click = audio.loadSound( "click.wav" )



if composer.getVariable( "sound" )==nil then
	composer.setVariable( "sound",true )
end


function scene:create( event )
    local sceneGroup = self.view

    if composer.getVariable( "sound" ) then
    	audio.setVolume(0.5, {channel=1})
    	audio.setVolume(1, {channel=2})
    else
    	audio.setVolume(0, {channel=1})
    	audio.setVolume(0, {channel=2})
    end



    background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background:setFillColor( 0.9)

    grass = display.newImageRect( sceneGroup, "ground.png", screenW, screenH)
    grass.anchorX = 0
    grass.anchorY = 1  --  draw the grass at the very bottom of the screen
    grass.x, grass.y = display.screenOriginX, display.actualContentHeight*1.8 + display.screenOriginY
    grass.alpha=0.7

    titleLogo = display.newImageRect(sceneGroup, "logo.png", 250, 60 )
    titleLogo.x = display.contentCenterX
    titleLogo.y = display.contentCenterY*0.6

    for _=1,3 do
        clouds.new(sceneGroup, math.random(display.actualContentWidth), math.random(0, display.actualContentHeight/4.5))
    end

    author = display.newText( sceneGroup, "Authors:", display.contentCenterX, display.contentCenterY*0.8, native.systemFont, 15 )
    author.align="center"
    author:setFillColor(0,0,0)
    about = display.newText( sceneGroup, "Simone Rossetti\n\nAlessandro Rizzo", display.contentCenterX, display.contentCenterY, native.systemFont, 15 )
    about.align="center"
    about:setFillColor(0,0,0)

    local function onBackBtnRelease()
        -- go to game.lua scene
        audio.play(click, {channel=2})
        composer.removeScene( "highScores")
       	composer.gotoScene( "menu", "fade", 400 )
        return true	-- indicates successful touch
    end
    local backBtn = widget.newButton{
        textOnly=true,
        label="Back",
        labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
        default="button.png",
        over="button-over.png",
        width=200, height=50,
        onRelease = onBackBtnRelease	-- event listener function
    }
    backBtn.x = display.contentCenterX*0.2
    backBtn.y = display.contentCenterY-display.contentCenterY
    sceneGroup:insert( backBtn )

    local balloon=balloon.new(sceneGroup, display.contentCenterX,  display.contentCenterY*1.3)
    corda=display.newImageRect( sceneGroup, "corda.png", 1,grass.y-grass.height-balloon.y)
    corda.x,corda.y=balloon.x,balloon.y+balloon.height
    corda.alpha=0.4
    balloon:toFront()
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end


function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        composer.removeScene( "highScores" )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end


function scene:destroy( event )
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.dispose(click)
    click=nil
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
