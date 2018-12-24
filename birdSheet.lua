

local sheetInfo = require("mysheet")
local myImageSheet = graphics.newImageSheet( "birdSheet.png", sheetInfo:getSheet() )
local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {

        {
            -- bird01
            x=1,
            y=1,
            width=700,
            height=700,

        },
        {
            -- bird02
            x=700,
            y=1,
            width=700,
            height=700,

        },
        {
            -- bird03
            x=1400,
            y=1,
            width=700,
            height=700,

        },
        {
            -- bird04
            x=2100,
            y=1,
            width=700,
            height=700,

        },
    },

    sheetContentWidth = 2800,
    sheetContentHeight = 700
}

SheetInfo.frameIndex =
{

    ["bird01"] = 1,
    ["bird02"] = 2,
    ["bird03"] = 3,
    ["bird04"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
