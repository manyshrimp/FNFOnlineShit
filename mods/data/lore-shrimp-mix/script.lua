local doChain = false

local chainLevel = 0
local chainPos = 0
local chainElapsed = 0

local chainTime = 2

local function lerp(a,b,c) return a + (b-a) * c end

function onCreate()
    makeLuaSprite('chainBar','chainBar/chainBarLine',screenWidth-100,0)
    setObjectCamera('chainBar','hud')
    screenCenter('chainBar','y')
    addLuaSprite('chainBar',true)

    makeLuaSprite('chainBarBG1','chainBar/chainBarBG',screenWidth-100,getProperty('chainBar.y'))
    setObjectCamera('chainBarBG1','hud')
    addLuaSprite('chainBarBG1',true)
    setObjectOrder('chainBarBG1',getObjectOrder('chainBar')-1)

    makeLuaSprite('chainBarBG2','chainBar/chainBarBG',screenWidth-100,getProperty('chainBar.y'))
    setObjectCamera('chainBarBG2','hud')
    addLuaSprite('chainBarBG2',true)
    setObjectOrder('chainBarBG2',getObjectOrder('chainBar')-1)

    setProperty('chainBarBG1.color',getColorFromHex('1ce878'))
    setProperty('chainBarBG2.color',getColorFromHex('e81c1c'))

    makeLuaSprite('chainIcon','',0,0)
    setObjectCamera('chainIcon','hud')
    addLuaSprite('chainIcon',true)

    makeLuaSprite('chainIconFake','chainBar/chainIcon',getProperty('chainBar.x')-75,50)
    setObjectCamera('chainIconFake','hud')
    addLuaSprite('chainIconFake',true)

    setProperty('chainBarBG2._frame.frame.height',1)
end

function onSongStart()
    doChain = true
end

local ticks = {
    0,
    160,
    275,
    380,
    539
}

function onUpdatePost(elapsed)
    if doChain then
        if not botPlay and not practice then
            if rating < 0.9 and ratingName ~= 's' then
                chainElapsed = chainElapsed + elapsed
                if chainElapsed > chainTime then
                    chainElapsed = chainElapsed % chainTime
                    chainLevel = chainLevel + 1

                    doTweenY('chainBar1','chainIcon',ticks[chainLevel+1],0.8,'bounceOut')
                end
            else
                chainElapsed = 0
            end

            

            chainPos = getProperty('chainIcon.y')
            setProperty('chainBarBG2._frame.frame.height',math.max(chainPos,1))

            if chainPos > 520 then 
                setHealth(-1)
            end
        end
        setProperty('chainIconFake.x',getProperty('chainBar.x')-75+math.random(-2,2))
        setProperty('chainIconFake.y',chainPos+50+math.random(-2,2))
        setProperty('chainIconFake.angle',math.random(-2,2))
    end
end