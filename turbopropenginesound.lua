-------------X-Plane and SASL volume controls
defineProperty("mastervol", globalPropertyf("com/dkmp/mastervol"))
defineProperty("mastervolknob", globalPropertyf("com/dkmp/mastervolknob"))
defineProperty("XPsound", globalPropertyf("sim/operation/sound/sound_on"))
defineProperty("pause", globalPropertyf("sim/time/paused"))

------------Camera positions and angles
defineProperty("view", globalPropertyi("sim/graphics/view/view_is_external"))
defineProperty("viewHDG", globalPropertyf("sim/graphics/view/view_heading"))

------------Sound Sources
defineProperty("PropRPM", globalPropertyf("sim/cockpit2/engine/indicators/prop_speed_rpm[0]"))
defineProperty("battery_on", globalPropertyi("sim/cockpit/electrical/battery_on"))  -- ON/OFF main battery
defineProperty("ignition_key", globalPropertyi("sim/cockpit2/engine/actuators/ignition_key[0]"))
defineProperty("reverse", globalPropertyi("sim/flightmodel2/engines/thrust_ReverseaR_deploy_ratio[0]"))

------------Aircraft Positions and angles
defineProperty("acfyaw", globalPropertyf("sim/flightmodel/position/psi"))
defineProperty("acfroll", globalPropertyf("sim/flightmodel/position/phi"))
defineProperty("sim_speed", globalPropertyi("sim/time/sim_speed"))
defineProperty("time", globalPropertyf("sim/time/total_flight_time_sec"))
defineProperty("FN", globalPropertyf("frame_number")) -- flight time
defineProperty("frame_time", globalPropertyf("frame_time"))
defineProperty("dist", globalPropertyf("com/dkmp/dist"))
defineProperty("SoundDir", globalPropertyf("com/dkmp/SoundDir"))
defineProperty("SoundFB", globalPropertyf("com/dkmp/SoundFB"))
defineProperty("SoundLR", globalPropertyf("com/dkmp/SoundLR"))

--###############################################################################

------------START
SparkL = loadSample('sounds/custom/SparkExtL.wav')
SparkR = loadSample('sounds/custom/SparkExtR.wav')
SparkiL = loadSample('sounds/custom/SparkIntL.wav')
SparkiR = loadSample('sounds/custom/SparkIntR.wav')
IgnitionL = loadSample('sounds/custom/IgnitionL.wav')
IgnitionR = loadSample('sounds/custom/IgnitionR.wav')
IgnitioniL = loadSample('sounds/custom/IgnitionIntL.wav')
IgnitioniR = loadSample('sounds/custom/IgnitionIntR.wav')

------------REVERSE LOW RPM
ReverseaL = loadSample('sounds/custom/ReverseaL.wav')
ReverseaR = loadSample('sounds/custom/ReverseaR.wav')
ReversebL = loadSample('sounds/custom/ReversebL.wav')
ReversebR = loadSample('sounds/custom/ReversebR.wav')
ReverseiL = loadSample('sounds/custom/ReverseiL.wav')
ReverseiR = loadSample('sounds/custom/ReverseiR.wav')

------------LOW RPM
prop1aL = loadSample('sounds/custom/prop1aL.wav')
prop1aR = loadSample('sounds/custom/prop1aR.wav')
prop1bL = loadSample('sounds/custom/prop1bL.wav')
prop1bR = loadSample('sounds/custom/prop1bR.wav')
prop1iL = loadSample('sounds/custom/prop1iL.wav')
prop1iR = loadSample('sounds/custom/prop1iR.wav')

------------HIGH RPM
prop2aL = loadSample('sounds/custom/prop2aL.wav')
prop2aR = loadSample('sounds/custom/prop2aR.wav')
prop2bL = loadSample('sounds/custom/prop2bL.wav')
prop2bR = loadSample('sounds/custom/prop2bR.wav')
prop2iL = loadSample('sounds/custom/prop2iL.wav')
prop2iR = loadSample('sounds/custom/prop2iR.wav')

--###############################################################################

	setSampleGain(SparkL, 0)
	setSampleGain(SparkR, 0)	
	setSampleGain(SparkiL, 0)
	setSampleGain(SparkiR, 0)	
	setSampleGain(IgnitionL, 0)	
	setSampleGain(IgnitionR, 0)		
	setSampleGain(IgnitioniL, 0)	
	setSampleGain(IgnitioniR, 0)
		
	setSampleGain(ReverseaL, 0)	
	setSampleGain(ReverseaR, 0)	
	setSampleGain(ReversebL, 0)	
	setSampleGain(ReversebR, 0)		
	setSampleGain(ReverseiL, 0)	
	setSampleGain(ReverseiR, 0)	
	
	setSampleGain(prop1aL, 0)
	setSampleGain(prop1aR, 0)	
	setSampleGain(prop1bL, 0)	
	setSampleGain(prop1bR, 0)	
	setSampleGain(prop1iL, 0)
	setSampleGain(prop1iR, 0)	
	
	setSampleGain(prop2aL, 0)	
	setSampleGain(prop2aR, 0)	
	setSampleGain(prop2bL, 0)	
	setSampleGain(prop2bR, 0)	
	setSampleGain(prop2iL, 0)	
	setSampleGain(prop2iR, 0)	
	
--###############################################################################

function update()

dist_old = get(dist)
view_old = get(view)

FT = get(frame_time)

------------Prepare the value for "V" (Volume)
if get(sim_speed) >= 1  then
V = get(mastervolknob) * get(XPsound) 
else
V = 0
end

------------Prepare value for "Z" (rotation of camera relative to plane)
Z= (get(viewHDG)) - (get(acfyaw))

------------Set sound direction equal to "Z"
set(SoundDir, Z)

------------Convert Z value to radians, then take the negative cosine of the result to set front/back sound volume
set(SoundFB, -math.cos(math.rad(Z))/2)

------------Convert Z value to radians, then take the sine of the result to set left/right sound volume
set(SoundLR, math.sin(math.rad(Z))/2)

------------Set low RPM Prop volume value
if (4200 - get(PropRPM)*2)/2000 > 0 and  get(PropRPM) > 600    then
RpL= (4200 - get(PropRPM)*2)/get(PropRPM)
elseif  get(PropRPM) < 600 then
RpL= (get(PropRPM)^2)*0.00001
else
RpL = 0
end

------------Set high RPM Prop volume value
if ((get(PropRPM)*4)-2000)/1000 > 0  then
RpH= ((get(PropRPM)*4)-2000)/1000
else
RpH= 0
end

		m = 50
		m2 = 100
		n = 1

------------Set sample gain of different sound waves, based on position, distance, volumes, etc.
local v=get(view)

--GAIN###############################################################################

if get(v) == 1 then ------------EXTERNAL sounds
	
	------------Spark & ignition Sounds Sounds
	setSampleGain(SparkL, 50)
	setSampleGain(SparkR, 50)
	setSampleGain(SparkiL, 0)
	setSampleGain(SparkiR, 0)	
	setSampleGain(IgnitionL, 50)
	setSampleGain(IgnitionR, 50)
	setSampleGain(IgnitioniL, 0)
	setSampleGain(IgnitioniR, 0)	
	------------Reverse Low RPM Prop Sounds
	setSampleGain(ReverseaL, (get(SoundFB)+get(SoundLR))*V*RpL*m)
	setSampleGain(ReverseaR, (get(SoundFB)-get(SoundLR))*V*RpL*m)
	setSampleGain(ReversebL, (-get(SoundFB)+get(SoundLR))*V*RpL*m)
	setSampleGain(ReversebR, (-get(SoundFB)-get(SoundLR))*V*RpL*m)
	setSampleGain(ReverseiL, 0)
	setSampleGain(ReverseiR, 0)
	------------Low RPM Prop Sounds	
	setSampleGain(prop1aL, (get(SoundFB)+get(SoundLR))*V*RpL*m)
	setSampleGain(prop1aR, (get(SoundFB)-get(SoundLR))*V*RpL*m)	
	setSampleGain(prop1bL, (-get(SoundFB)+get(SoundLR))*V*RpL*m)	
	setSampleGain(prop1bR, (-get(SoundFB)-get(SoundLR))*V*RpL*m)
	setSampleGain(prop1iL, 0)
	setSampleGain(prop1iR, 0)
	------------High RPM Prop Sounds
	setSampleGain(prop2aL, (get(SoundFB)+get(SoundLR))*V*RpH*m2)	
	setSampleGain(prop2aR, (get(SoundFB)-get(SoundLR))*V*RpH*m2)	
	setSampleGain(prop2bL, (-get(SoundFB)+get(SoundLR))*V*RpH*m2)	
	setSampleGain(prop2bR, (-get(SoundFB)-get(SoundLR))*V*RpH*m2)	
	setSampleGain(prop2iL, 0)	
	setSampleGain(prop2iR, 0)	
		
elseif get(v) == 0 then ------------INTERNAL sounds
	
	------------Spark & ignition Sounds Sounds
	setSampleGain(SparkL, 0)
	setSampleGain(SparkR, 0)
	setSampleGain(SparkiL, 25)
	setSampleGain(SparkiR, 25)
	setSampleGain(IgnitionL, 0)
	setSampleGain(IgnitionR, 0)
	setSampleGain(IgnitioniL, 25)
	setSampleGain(IgnitioniR, 25)
	------------Reverse Low RPM Prop Sounds
	setSampleGain(ReverseaL, 0)
	setSampleGain(ReverseaR, 0)
	setSampleGain(ReversebL, 0)
	setSampleGain(ReversebR, 0)
	setSampleGain(ReverseiL, (n+get(SoundLR))*V*RpL*m)
	setSampleGain(ReverseiR, (n-get(SoundLR))*V*RpL*m)
	------------Low RPM Prop Sounds	
	setSampleGain(prop1aL, 0)
	setSampleGain(prop1aR, 0)	
	setSampleGain(prop1bL, 0)	
	setSampleGain(prop1bR, 0)
	setSampleGain(prop1iL, (n+get(SoundLR))*V*RpL*m)
	setSampleGain(prop1iR, (n-get(SoundLR))*V*RpL*m)	
	------------High RPM Prop Sounds
	setSampleGain(prop2aL, 0)	
	setSampleGain(prop2aR, 0)	
	setSampleGain(prop2bL, 0)	
	setSampleGain(prop2bR, 0)		
	setSampleGain(prop2iL, (n+get(SoundLR))*V*RpH*m2)	
	setSampleGain(prop2iR, (n-get(SoundLR))*V*RpH*m2)	

end	

--PITCH###############################################################################

------------Calculate Doppler effect (Change of pitch depending on whether approaching or leaving reference point.)
Dp= 1000 + ((dist_old - get(dist))*60)
P= get(PropRPM)*0.0005
C=4

	------------Spark & ignition Sounds Pitch
	setSamplePitch(SparkL, 760 + get(PropRPM)*0.4)
	setSamplePitch(SparkR, 760 + get(PropRPM)*0.4)
	setSamplePitch(SparkiL, 760 + get(PropRPM)*0.4)
	setSamplePitch(SparkiR, 760 + get(PropRPM)*0.4)
	setSamplePitch(IgnitionL, 760 + get(PropRPM)*0.4)
	setSamplePitch(IgnitionR, 760 + get(PropRPM)*0.4)
	setSamplePitch(IgnitioniL, 760 + get(PropRPM)*0.4)
	setSamplePitch(IgnitioniR, 760 + get(PropRPM)*0.4)	
	------------ Reverse Low RPM Prop Pitch
	setSamplePitch(ReverseaL, Dp*P*C)	
	setSamplePitch(ReverseaR, Dp*P*C)
	setSamplePitch(ReversebL, Dp*P*C)
	setSamplePitch(ReversebR, Dp*P*C)
	setSamplePitch(ReverseiL, Dp*P*C)	
	setSamplePitch(ReverseiR, Dp*P*C)
	------------ Low RPM Prop Pitch
	setSamplePitch(prop1aL, Dp*P*C)	
	setSamplePitch(prop1aR, Dp*P*C)	
	setSamplePitch(prop1bL, Dp*P*C)	
	setSamplePitch(prop1bR, Dp*P*C)	
	setSamplePitch(prop1iL, Dp*P*C)	
	setSamplePitch(prop1iR, Dp*P*C)	
	------------High RPM Prop Pitch
	setSamplePitch(prop2aL, Dp*P)	
	setSamplePitch(prop2aR, Dp*P)	
	setSamplePitch(prop2bL, Dp*P)	
	setSamplePitch(prop2bR, Dp*P)
	setSamplePitch(prop2iL, Dp*P)	
	setSamplePitch(prop2iR, Dp*P)	

--PLAYING###############################################################################
	
------------Spark & ignition Sounds playing
if  get(ignition_key) == 4  and get(battery_on) == 1 and get(PropRPM) < 100 then
	if isSamplePlaying(SparkL) == false then playSample(SparkL, 1) end
	if isSamplePlaying(SparkR) == false then playSample(SparkR, 1) end	
	if isSamplePlaying(SparkiL) == false then playSample(SparkiL, 1) end
	if isSamplePlaying(SparkiR) == false then playSample(SparkiR, 1) end	
else
	stopSample(SparkL)
	stopSample(SparkR)
	stopSample(SparkiL)
	stopSample(SparkiR)
end

if  get(ignition_key) == 4  and get(battery_on) == 1 and get(PropRPM) < 650 then		
	if isSamplePlaying(IgnitionL) == false then	playSample(IgnitionL, 0) end
	if isSamplePlaying(IgnitionR) == false then	playSample(IgnitionR, 0) end
	if isSamplePlaying(IgnitioniL) == false then playSample(IgnitioniL, 0) end
	if isSamplePlaying(IgnitioniR) == false then playSample(IgnitioniR, 0) end
else
	stopSample(IgnitionL)
	stopSample(IgnitionR)
	stopSample(IgnitioniL)
	stopSample(IgnitioniR)
end

------------Reverse Sounds playing	
if  get(reverse) == 1 then		
	if isSamplePlaying(ReverseaL) == false then	playSample(ReverseaL, 0) end
	if isSamplePlaying(ReverseaR) == false then	playSample(ReverseaR, 0) end
	if isSamplePlaying(ReversebL) == false then	playSample(ReversebL, 0) end
	if isSamplePlaying(ReversebR) == false then	playSample(ReversebR, 0) end
	if isSamplePlaying(ReverseiL) == false then	playSample(ReverseiL, 0) end
	if isSamplePlaying(ReverseiR) == false then	playSample(ReverseiR, 0) end
else
	stopSample(ReverseaL)
	stopSample(ReverseaR)
	stopSample(ReversebL)
	stopSample(ReversebR)
	stopSample(ReverseiL)
	stopSample(ReverseiR)
end

------------Low RPM Prop Sounds playing
if  get(reverse) == 0 then		
	if isSamplePlaying(prop1aL) == false  then playSample(prop1aL, 1) end
	if isSamplePlaying(prop1aR) == false  then	playSample(prop1aR, 1) end
	if isSamplePlaying(prop1bL) == false  then	playSample(prop1bL, 1) end
	if isSamplePlaying(prop1bR) == false  then	playSample(prop1bR, 1) end
	if isSamplePlaying(prop1iL) == false  then playSample(prop1iL, 1) end
	if isSamplePlaying(prop1iR) == false  then	playSample(prop1iR, 1) end
else
	stopSample(prop1aL)
	stopSample(prop1aR)
	stopSample(prop1bL)
	stopSample(prop1bR)
	stopSample(prop1iL)
	stopSample(prop1iR)
end

------------High RPM Prop Sounds playing
if  get(reverse) == 0 then		
	if isSamplePlaying(prop2aL) == false  then 	playSample(prop2aL, 1) end
	if isSamplePlaying(prop2aR) == false  then 	playSample(prop2aR, 1) end
	if isSamplePlaying(prop2bL) == false  then 	playSample(prop2bL, 1) end
	if isSamplePlaying(prop2bR) == false  then 	playSample(prop2bR, 1) end
	if isSamplePlaying(prop2iL) == false  then 	playSample(prop2iL, 1) end
	if isSamplePlaying(prop2iR) == false  then 	playSample(prop2iR, 1) end
else
	stopSample(prop2aL)
	stopSample(prop2aR)
	stopSample(prop2bL)
	stopSample(prop2bR)
	stopSample(prop2iL)
	stopSample(prop2iR)
end

dist_old = get(dist)
view_old = get(view)

end
