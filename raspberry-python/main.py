#!/usr/bin/python

from OSC import OSCClient, OSCMessage
client = OSCClient()
client.connect( ("192.168.1.117", 12007) )

from OSC import OSCClient, OSCMessage
import time

import bluepy

BLE_Scratch_service_UUID="a495ff20-c5b1-4b44-b512-1370f02d74de"
BLE_Scratch1_characteristic_UUID="a495ff21-c5b1-4b44-b512-1370f02d74de"
BLE_Scratch2_characteristic_UUID="a495ff22-c5b1-4b44-b512-1370f02d74de"
BLE_Scratch3_characteristic_UUID="a495ff23-c5b1-4b44-b512-1370f02d74de"
BLE_Scratch4_characteristic_UUID="a495ff24-c5b1-4b44-b512-1370f02d74de"
BLE_Scratch5_characteristic_UUID="a495ff25-c5b1-4b44-b512-1370f02d74de"

print "Searching"
BLE_device = bluepy.btle.Peripheral("98:7B:F3:59:20:C4")   
print "Device Found & connected"

BLE_Scratch_service=BLE_device.getServiceByUUID(BLE_Scratch_service_UUID)
print "Found Scratch service:"
print BLE_Scratch_service

print "Looking for scratch service characteristics"
BLE_Scratch1_characteristics=BLE_Scratch_service.getCharacteristics(BLE_Scratch1_characteristic_UUID)
BLE_Scratch2_characteristics=BLE_Scratch_service.getCharacteristics(BLE_Scratch2_characteristic_UUID)
BLE_Scratch3_characteristics=BLE_Scratch_service.getCharacteristics(BLE_Scratch3_characteristic_UUID)
ser1_c_len=len(BLE_Scratch1_characteristics)
print "Found", ser1_c_len, "Characteristics:"
print BLE_Scratch1_characteristics

def diff( oldval, newval ):
	diff = oldval - newval
	if (diff >= 255):
		diff -= 255
	if (diff <= -255):
		diff += 255
	return diff

row_cnt = 0;

diffX = 0
diffY = 0
diffZ = 0

prevX = 0
prevY = 0
prevZ = 0

#while row_cnt < 100:
while True:
	data1 = BLE_Scratch1_characteristics[0].read()
	data2 = BLE_Scratch2_characteristics[0].read()
	data3 = BLE_Scratch3_characteristics[0].read()

	newX = ord(data1[0])
	newY = ord(data2[0])
	newZ = ord(data3[0])
	
	diffX =  diff(prevX, newX)
	diffY =  diff(prevY, newY)
	diffZ =  diff(prevZ, newZ)

	prevX = newX
	prevY = newY
	prevZ = newZ
	
	print str(diffX) + " : " + str(diffY) + " : " + str(diffZ)
	client.send( OSCMessage(str(diffX) + ":" + str(diffY) + ":" + str(diffZ)) )

	row_cnt += 1
	#time.sleep(1)
BLE_device.disconnect()
