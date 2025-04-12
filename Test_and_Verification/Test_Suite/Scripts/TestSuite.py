############################################################
# TestSuite.py 
# 4/8/25
# Stephen Bianchi
# History of Modification
#
# This module is desinged to be placed into the blender
# Scripts tab and run there. It will setup multiple scenarios
# and capture images.
############################################################

import bpy
import numpy as np
import socket
import struct
from mathutils import Euler
import math
from configparser import ConfigParser
import os

##################################
#Global Variable import
##################################

#Promt for Global File


#Find the Global Config
#TODO replace with promt
Global_File_Path = "S:/tennis-ball-tracking/Test_and_Verification/Test_Suite/Global.ini"

#Setup Config Parser
global_config = ConfigParser()
global_config.read(Global_File_Path)

#Path to Scenario Groups
Scen_Groups_Path = global_config['FilePaths']['Scenario_Group_Path']


###################################
#Test Deocument Import
###################################

ScenarioGroup = '\Default_Scenario_Group'
Scenarios = '\Default_Scenario'

Scenario_Path = Scen_Groups_Path+ScenarioGroup+Scenarios
print(Scenario_Path)

####################################
#Scenario Import
####################################
cam_config = ConfigParser()
cam_config.read(Scenario_Path+"\camera.ini")

Focal_Length = cam_config['Camera_Settings']['Focal_Length']


#####################################
#Update Camera
######################################
obj = bpy.data.objects["Camera"]
obj.data.lens = int(Focal_Length)
print(obj.items())

 

def xform_object_by_name(object_name,x,y,z,pitch,roll,yaw):
    if object_name in bpy.data.objects:
        obj = bpy.data.objects[object_name]
        obj.location = (x, y, z)
        pitchRad = math.radians(pitch)
        rollRad = math.radians(roll)
        yawRad = math.radians(yaw)
        obj.rotation_euler = Euler((pitchRad, rollRad, yawRad), 'XYZ')
    else:
        print(f"Object '{object_name}' not found.")
    