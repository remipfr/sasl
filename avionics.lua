size = { 2048, 2048 }

--------- enginesound1, enginesound1, sound
createProp("maxF", "float", 260);
createProp("minF", "float", 35);
createProp("maxB", "float", 375);
createProp("minB", "float", 225);
createProp("frame_time", "float", 0); -- time since last frame
createProp("com/dkmp/mastervol", "float", 1);
createProp("com/dkmp/mastervolknob", "float", 1);
createProp("com/dkmp/frame_number", "int", 0);
createProp("com/dkmp/dist", "float", 0);
createProp("com/dkmp/SoundDir", "float", 0);
createProp("com/dkmp/SoundFB", "float", 0);
createProp("com/dkmp/SoundLR", "float", 0);
createProp("volumeX", "float", 1); 
createProp("volumeSon", "float", 1); 

--###############################################################################

components = {
timelogic{}, 
lowbypassenginesound{}, 
weaponsound{}, 
sound{}, 
}
