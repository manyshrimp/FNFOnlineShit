function onCreate()
	makeAnimatedLuaSprite('hypnoEntrance', 'ABOMINATION_HYPNO_ENTRANCE', 585, -155)
	--setScrollFactor('hypnoEntrance', 0.95, 0.95);
	--scaleObject("hypnoEntrance", 1.25, 1.25 , true)
	setProperty("hypnoEntrance.visible", false)
	addAnimationByPrefix("hypnoEntrance", "Entrance instance", "Entrance instance", 24, false)
	addLuaSprite('hypnoEntrance', true);

	setProperty("defaultCamZoom", 1.5)
	triggerEvent("Change Character", "Dad", "bfhypno")
	setProperty("dad.visible", false)
	setProperty('skipCountdown', true)
	
	makeAnimatedLuaSprite('coolgf','characters/gf/gfphase3',0,-500,'tex')
	addAnimationByIndicesLoop('coolgf','idle','GF_SHAKING_BF_she_is_like_real_hot_tho_because_she_is_lullaby_girlfriend','0,1,2,3,4,5,6,7,8,9,10,11,12,13',24)
	playAnim('coolgf','idle')
	addLuaSprite('coolgf',true)
end