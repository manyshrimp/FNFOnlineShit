function onCountdownStarted()
    setProperty('skipCountdown',true)
end

local Shintoed = false
function onUpdate()
  	if getProperty("health") <= 0.001 then
  		setProperty("health", 0.001)
  		runHaxeCode("FlxG.sound.music.stop();")
  		if not Shintoed	then
  		 setProperty('inCutscene', true)
  		 setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0);
  		 playAnim("dad", "lose")
  		 playSound("ShintoRetry", 1)
  		 addHaxeLibrary('MainMenuState')
  		 runTimer("deathhahayes", 1.13)
  		 runTimer("heeehe", 0.22, 0)
  		end
  		Shintoed = true
  	end
end



function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "deathhahayes" then
    	runHaxeCode("FlxG.switchState(new MainMenuState());")
    elseif tag == "heeehe" then
    	setProperty("camHUD.alpha", getProperty("camHUD.alpha") - 0.34)
    end
end