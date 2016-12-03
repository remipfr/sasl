-------------X-Plane and SASL volume controls
defineProperty("mastervolknob", globalPropertyf("com/dkmp/mastervolknob"))
defineProperty("XPsound", globalPropertyf("sim/operation/sound/sound_on"))
defineProperty("view", globalPropertyf("sim/graphics/view/view_is_external"))
defineProperty("gun_req", globalPropertyf("sim/weapons/next_bull_time")) 
defineProperty("sim_speed", globalPropertyi("sim/time/sim_speed"))

--###############################################################################

------------gunfire
GFO = loadSample('sounds/custom/gunfireout.wav')
GFI = loadSample('sounds/custom/gunfirein.wav')

--###############################################################################

setSampleGain(GFO, 0)	
setSampleGain(GFI, 0)
	
--###############################################################################
local gun = 0  -- assume starts up this way
local gun_prev = 0

function update()

------------Prepare the value for "V" (Volume)
if get(sim_speed) >= 1  then
V = get(mastervolknob) * get(XPsound) 
else
V = 0
end

local v=get(view)

--GAIN###############################################################################

------------EXTERNAL sounds
if get(v) == 1 then
	
	------------Gunfire gain
	setSampleGain(GFO, V*500)
	setSampleGain(GFI, 0)

------------INTERNAL sounds
elseif get(v) == 0 then
	
	------------Gunfire gain
	setSampleGain(GFO, 0)
	setSampleGain(GFI, V*500)

end	

--PITCH###############################################################################

P= 1000
	------------Gunfire pitch
	setSamplePitch(GFO, P)
	setSamplePitch(GFI, P)

--PLAYING###############################################################################

	gun = get(gun_req)
	
	if gun ~= gun_prev then		-- request for change made
		playSample(GFO, 0)
		playSample(GFI, 0)
		gun_prev = gun
		
	elseif gun == gun_prev then 
		stopSample(GFO)
		stopSample(GFI)
	end

end