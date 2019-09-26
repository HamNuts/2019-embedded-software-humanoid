# -*- coding: utf-8 -*-

import platform
import numpy as np
import argparse
import cv2
import serial
import time
import sys
import threading

#updated : 2019. 7.12
#contents : 1.object's position detection, 2.yellow line detection 3. blue line detection 4. make contents function forms
#-----------------------------------------------
Top_name = 'mini CTS4 setting'
hsv_Lower = 0
hsv_Upper = 0
# 0 :
# 1 :
# 2 : Red
# 3 :
# 4 : Blue h:110~74 s:255~133 v:255~104
# 5 : Yellow
# 6 : Green
# 7 :
# 8 :
# 9 :

color_num = [  0,  1,  2,  3,  4,  5,  6,  7,  8,  9]
    
h_max =     [ 48, 64,196,111,130, 42, 70, 62, 62, 62]
h_min =     [ 11, 25,158, 59, 80,  20, 29, 29, 29, 29]
    
s_max =     [248,255,223,110,255,255,190,178,178,178]
s_min =     [ 70,164,150, 51,133,134, 70, 51, 51, 51]
    
v_max =     [237,255,239,156,255,253,236,236,236,236]
v_min =     [173,129,54, 61, 50, 84, 22, 22, 22, 22]
    
min_area =  [ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]

now_color = 0
serial_use = 0

serial_port =  None
Temp_count = 0
Read_RX =  0

target_x = 0
target_y = 0
center=(0,0)
x_low = 0
x_high = 0
y_low = 0
y_high = 0

blue_line = 0
yellow_line = 0
milk_pack = 0
cocacola = 0
lineLamp=0
Read_RX=0
Old_RX=0
#-----------------------------------------------

def nothing(x):
    pass

#-----------------------------------------------
def create_blank(width, height, rgb_color=(0, 0, 0)):

    image = np.zeros((height, width, 3), np.uint8)
    color = tuple(reversed(rgb_color))
    image[:] = color

    return image
#-----------------------------------------------
def draw_str2(dst, target, s):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 0.8, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 0.8, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def draw_str3(dst, target, s):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 1.5, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN,1.5, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def draw_str_height(dst, target, s, height):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, height, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, height, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#-----------------------------------------------

def Trackbar_change(now_color):
    global  hsv_Lower,  hsv_Upper
    hsv_Lower = (h_min[now_color], s_min[now_color], v_min[now_color])
    hsv_Upper = (h_max[now_color], s_max[now_color], v_max[now_color])

#-----------------------------------------------
def Hmax_change(a):
    
    h_max[now_color] = cv2.getTrackbarPos('Hmax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Hmin_change(a):
    
    h_min[now_color] = cv2.getTrackbarPos('Hmin', Top_name) 
    Trackbar_change(now_color)
#-----------------------------------------------
def Smax_change(a):
    
    s_max[now_color] = cv2.getTrackbarPos('Smax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Smin_change(a):
    
    s_min[now_color] = cv2.getTrackbarPos('Smin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Vmax_change(a):
    
    v_max[now_color] = cv2.getTrackbarPos('Vmax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Vmin_change(a):
    
    v_min[now_color] = cv2.getTrackbarPos('Vmin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def min_area_change(a):
   
    min_area[now_color] = cv2.getTrackbarPos('Min_Area', Top_name)
    if min_area[now_color] == 0:
        min_area[now_color] = 1
        cv2.setTrackbarPos('Min_Area', Top_name, min_area[now_color])
    Trackbar_change(now_color)
#-----------------------------------------------
def Color_num_change(a):
    global now_color, hsv_Lower,  hsv_Upper
    now_color = a
    cv2.setTrackbarPos('Hmax', Top_name, h_max[a])
    cv2.setTrackbarPos('Hmin', Top_name, h_min[a])
    cv2.setTrackbarPos('Smax', Top_name, s_max[a])
    cv2.setTrackbarPos('Smin', Top_name, s_min[a])
    cv2.setTrackbarPos('Vmax', Top_name, v_max[a])
    cv2.setTrackbarPos('Vmin', Top_name, v_min[a])
    cv2.setTrackbarPos('Min_Area', Top_name, min_area[now_color])
    cv2.setTrackbarPos('Color_num', Top_name,a)

    hsv_Lower = (h_min[now_color], s_min[now_color], v_min[now_color])
    hsv_Upper = (h_max[now_color], s_max[now_color], v_max[now_color])
#----------------------------------------------- 
def TX_data(serial, one_byte):  # one_byte= 0~255
    global Temp_count
    try:
        serial.write(chr(int(one_byte)))
    except:
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        pass
#-----------------------------------------------
def RX_data(serial):
    global Temp_count
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            return RX
        else:
            return 0
    except:
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        return 0
        pass
#-----------------------------------------------
###################################
#########user-define###############
###################################
def cornerCheck(serial_port,center,a,aa,aaa):
    for i in range(1,500): # for(x of center is left)

                        if cv2.pointPolygonTest(c,(center[0]+i,center[1]),False)==1: #if(center is inner of c) 
                            
                            if center[1]>230: #corner coordinates
                                print("left corner")
                                TX_data(serial_port,140)
                                a=1
                                aa=1
                                k=1
                                TX_data(serial_port, 140)
                                Read_RX =RX_data(serial_port)
                                while Read_RX <>140:
                                    
                                    Read_RX =RX_data(serial_port)
                                    print("Read_RX = " + str(Read_RX))
                                    k=(k+1)%100
                                    if k==0:
                                        TX_data(serial_port,140)
                                    key = 0xFF & cv2.waitKey(1)
                                    if key == 27:  # ESC  Key
                                         return aa
                                  
                                return aa
                            else:
                                if aaa==0:
                                    TX_data(serial_port,142)
                                return aa
                                
                            
    for i in range(1,center[0]+1):
                        if a==1:
                            break
                        if cv2.pointPolygonTest(c,(center[0]-i,center[1]),False)==1:
                            
                            if center[1]>220:#corner coordinates
                                print("right corner")  
                                a=2
                                k=1
                                aa=1
                                TX_data(serial_port,141)
                                Read_RX =RX_data(serial_port)
                                while Read_RX <>141:
                                    
                                    Read_RX =RX_data(serial_port)
                                    print("Read_RX = " + str(Read_RX))
                                    k=(k+1)%100
                                    if k==0:
                                        TX_data(serial_port,141)
                                    key = 0xFF & cv2.waitKey(1)
                                    if key == 27:  # ESC  Key
                                         return aa
                                return aa
                            else:
                                TX_data(serial_port,142)
                                return aa


#-----------------------------------------------
def lineScan(c,center,aa):
    print"aa in linScan=",aa
    b=1
    if cv2.pointPolygonTest(c,(center[0],center[1]-90),False)==1 and dist1>0:
        TX_data(serial_port,142)
        b=0
    
    if b==1 and aa==0:#not straight
        rows,cols = frame.shape[:2]
        [vx, vy, x, y] = cv2.fitLine(c, cv2.DIST_L2, 0,0.01,0.01)
        lefty = int((-x*vy/vx) +y)
        righty = int(((cols-x)*vy/vx)+y)
        try:
            cv2.line(frame,(cols-1, righty), (0, lefty), (0,255,0),2)
            lefty = float((-x*vy/vx) +y)
            righty = float(((cols-x)*vy/vx)+y)
        
            
        

            lineLamp = -(righty-lefty)/(cols-1)
            print("slope:",lineLamp)
            if now_color==5:
                if lineLamp<8 and lineLamp>4:
                    TX_data(serial_port,145)#right turn
                                        
                    a
                elif lineLamp>-11 and lineLamp<-4:
                    TX_data(serial_port,146)#left turn
                    a
                elif lineLamp>-5 and lineLamp<0:
                    TX_data(serial_port,148)#left turn
                    a
                elif lineLamp>0 and lineLamp<5:
                    TX_data(serial_port,147)#right turn
                    a
                aa=1
        except:
            pass
    elif (aa==2 ) and b==1 :
        TX_data(serial_port,142)#go straight
        
    return aa

#------------------------------------------------------            
def makeCNT(frame):
    mask = cv2.inRange(hsv, hsv_Lower, hsv_Upper)
            
    mask = cv2.erode(mask, None, iterations=1)
    mask = cv2.dilate(mask, None, iterations=1)
    #mask = cv2.GaussianBlur(mask, (3, 3), 2)  # softly       
    _,cnts,_ = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    return mask,cnts

#----------------------------------------------------------

def drawCNT():
    Color_num_change(now_color)
    mask,cnts=makeCNT(frame)
    if len(cnts) > 0:
        c = max(cnts,key=cv2.contourArea)
        cv2.drawContours(frame, c, -1, (0, 0, 255), 2) #draw contours
    else :
            c=cnts
            
    return c
#----------------------------------------------------------
def mouse_callback(event, x, y, flags, param):
    global hsv

    # 마우스 왼쪽 버튼 누를시 위치에 있는 픽셀값을 읽어와서 HSV로 변환합니다.
    if event == cv2.EVENT_LBUTTONDOWN:
        print'(x,y) = ','(',x,',',y,')'
        color = frame[y, x]

        one_pixel = np.uint8([[color]])
        hsv = cv2.cvtColor(one_pixel, cv2.COLOR_BGR2HSV)
        print 'hsv = ',hsv
#----------------------------------------------------------

def getRead_RX():
    global Read_RX
    while True:
        Read_RX = RX_data(serial_port)

        
# **************************************************
# **************************************************
# **************************************************
if __name__ == '__main__':

    #-------------------------------------
    print ("-------------------------------------")
    print ("(2018-6-15) mini CTS4 Program.    MINIROBOT Corp.")
    print ("-------------------------------------")
    print ("")
    os_version = platform.platform()
    print (" ---> OS " + os_version)
    python_version = ".".join(map(str, sys.version_info[:3]))
    print (" ---> Python " + python_version)
    opencv_version = cv2.__version__
    print (" ---> OpenCV  " + opencv_version)
    
    
    #-------------------------------------
    #---- user Setting -------------------
    #-------------------------------------
    W_View_size =  510 
    H_View_size = int(W_View_size / 1.777)  
    #H_View_size = int(W_View_size / 1.333)

    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200

    serial_use = 1

    now_color = 0
    
    View_select = 1
    dist1 = 0
    aa=0
    aaa=0
    #-------------------------------------
    print(" ---> Camera View: " + str(W_View_size) + " x " + str(H_View_size) )
    print ("")
    print ("-------------------------------------")
    #-------------------------------------
    ap = argparse.ArgumentParser()
    ap.add_argument("-v", "--video",
                    help="path to the (optional) video file")
    ap.add_argument("-b", "--buffer", type=int, default=64,
                    help="max buffer size")
    args = vars(ap.parse_args())

    img = create_blank(320, 50, rgb_color=(0, 0, 255))
    
    cv2.namedWindow(Top_name)

    
    cv2.createTrackbar('Hmax', Top_name, h_max[now_color], 255, Hmax_change)
    cv2.createTrackbar('Hmin', Top_name, h_min[now_color], 255, Hmin_change)
    cv2.createTrackbar('Smax', Top_name, s_max[now_color], 255, Smax_change)
    cv2.createTrackbar('Smin', Top_name, s_min[now_color], 255, Smin_change)
    cv2.createTrackbar('Vmax', Top_name, v_max[now_color], 255, Vmax_change)
    cv2.createTrackbar('Vmin', Top_name, v_min[now_color], 255, Vmin_change)
    cv2.createTrackbar('Min_Area', Top_name, min_area[now_color], 255, min_area_change)
    cv2.createTrackbar('Color_num', Top_name,color_num[now_color], 9, Color_num_change)

    Trackbar_change(now_color)

    draw_str3(img, (15, 25), 'MINIROBOT Corp.')
    
    cv2.imshow(Top_name, img)
    #---------------------------
    if not args.get("video", False):
        camera = cv2.VideoCapture(0)
    else:
        camera = cv2.VideoCapture(args["video"])
    #---------------------------
    camera.set(3, W_View_size)
    camera.set(4, H_View_size)
    camera.set(5, 60)

    time.sleep(0.5)
    #---------------------------
    if serial_use <> 0:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        serial_port.flush() # serial cls
    #---------------------------
    (grabbed, frame) = camera.read()
    draw_str2(frame, (5, 15), 'X_Center x Y_Center =  Area' )
    draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d.  Space: Fast <=> Video and Mask.'
                      % (W_View_size, H_View_size))
    draw_str_height(frame, (5, (H_View_size/2)), 'Fast operation...', 3.0 )
    cv2.imshow('mini CTS4 - Video', frame )
    #---------------------------
    # First -> Start Code Send 
    TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    
    old_time = clock()
    #-----------multy thread-----------

 
    # -------- Main Loop Start --------
    aa=0
    while True:
        dist1=0
        Area1=0
        Read_RX = 0
        # grab the current frame
        (grabbed, frame) = camera.read()

        if args.get("video") and not grabbed:
                break
           
        
        Read_RX = RX_data(serial_port)
        print "Read_RX = ",Read_RX
        if Read_RX > 99 :
            Color_num_change((Read_RX//10)%10)
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        mask = cv2.inRange(hsv, hsv_Lower, hsv_Upper)
               
        mask = cv2.erode(mask, None, iterations=1)
        mask = cv2.dilate(mask, None, iterations=1)
        #mask = cv2.GaussianBlur(mask, (3, 3), 2)  # softly
                
        _,cnts,_ = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
             
        cv2.namedWindow('mini CTS4 - Video')
        cv2.setMouseCallback('mini CTS4 - Video', mouse_callback)
        center = (0,0)
        
        if Read_RX > 99 and Old_RX<>Read_RX:
            Old_RX=Read_RX
            if len(cnts) > 0:
                c = max(cnts,key=cv2.contourArea)
                ((X, Y), radius) = cv2.minEnclosingCircle(c)
                
                Area1 = cv2.contourArea(c) / min_area[now_color]
                contourArea = cv2.contourArea(c)
                if Area1 > 255:
                    Area1 = 255
                        
                if Area1 > min_area[now_color]:
                    cv2.drawContours(frame, c, -1, (0, 0, 255), 2) #draw contours
                    x4, y4, w4, h4 = cv2.boundingRect(c) #rectangle setting
                    #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 0), 2) #draw rectangle 
                    mmt=cv2.moments(c)
                    
                    #cx=int(mmt['m10']/mmt['m00'])
                    
                    #cy=int(mmt['m01']/mmt['m00'])
                    target_x = x4*2+w4/2 #store x position of the object.
                    target_y = y4*2+w4/2 #sotre y position of the object.
                    #center=(cx,cy)
                    center=(x4+w4/2,y4+h4/2)
                    print center
                    dist1=cv2.pointPolygonTest(c,(center[0],center[1]),False)
        
                    
                    
                    #print((target_x, target_y)) #Here is center (x,y) of the object. 
                    cv2.circle(frame,center,3,(0,255,0),-1)
                    #print("x: ",center[0], "y: ",center[1], "\n")
                    
                    X_Size = int((255.0 / W_View_size) * w4)
                    Y_Size = int((255.0 / H_View_size) * h4)
                    X_255_point = int((255.0 / W_View_size) * X)
                    Y_255_point = int((255.0 / H_View_size) * Y)

                    if Read_RX % 10== 4:
                        rows,cols = frame.shape[:2]
                        [vx, vy, x, y] = cv2.fitLine(c, cv2.DIST_L2, 0,0.01,0.01)
                        lefty = int((-x*vy/vx) +y)
                        righty = int(((cols-x)*vy/vx)+y)
                        try:
                            cv2.line(frame,(cols-1, righty), (0, lefty), (0,255,0),2)
                            lineLamp = -(righty-lefty)/(cols-1)
                            
                            print("slope:",lineLamp)
                            if lineLamp<0:
                                lineLamp=lineLamp%100
                            else:
                                lineLamp=lineLamp%100+100
                        except:
                            lineLamp = 30
            
                        
            

                        
            else:
                
                x = 0
                y = 0
                X_255_point = 0
                Y_255_point = 0
                X_Size = 0
                Y_Size = 0
                Area1 = 0  
                
            '''
            #--------------------------------------
            
            Read_RX = RX_data(serial_port)
            if Read_RX <> 0:
                print("Read_RX = " + str(Read_RX))
            
            #TX_data(serial_port,255)
            
            #--------------------------------------    
            '''
            



            ############################################
            ############################################
            ############################################
            Read_TX=0
            
            if Read_RX % 10== 0:
                if Area1 > min_area[now_color]:
                  TX_data(serial_port,dist1+2+100)
                  Read_TX=dist1+2+100
                  
                else:
                   TX_data(serial_port,0)
            elif Read_RX % 10== 1:
                if Area1>0:
                    TX_data(serial_port,Area1)
                    Read_TX=Area1		
                else:
                    TX_data(serial_port,0)
                   
            elif Read_RX % 10== 2:
               if Area1>0:
                   TX_data(serial_port,(center[0]*255)//W_View_size)
                   Read_TX=(center[0]*255)//W_View_size
                   
               else:
                   TX_data(serial_port,0)               
            
            elif Read_RX % 10== 3:
                if Area1>0:
                   TX_data(serial_port,(center[1]*255)//H_View_size)
                   Read_TX=(center[1]*255)//H_View_size
                   
                else:
                   TX_data(serial_port,0)
            elif Read_RX % 10== 4:
                if Area1>0:
                   TX_data(serial_port,(lineLamp))
                   Read_TX=(lineLamp)
                  
                else:
                   TX_data(serial_port,0)
            elif Read_RX % 10== 5:
                if Area1>0:
                   TX_data(serial_port,(lineLamp%100+100))
                   Read_TX=(lineLamp%100+100)
                  
            else:
                TX_data(serial_port,0)            


            print "Read_TX = ",Read_TX
                    
                               

            

            ##########################################
            ##########################################
            ##########################################

        Frame_time = (clock() - old_time) * 1000.
        old_time = clock()       
        if View_select == 0: # Fast operation 
            print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                
        elif View_select == 1: # Debug
                #draw_str2(frame, (5, 15), 'X: %.1d,  Y: %.1d, Area: %.1d ' % (X_255_point, Y_255_point, Area1))
            draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'
                          % (W_View_size, H_View_size, Frame_time))
            cv2.imshow('mini CTS4 - Video', frame )
            cv2.imshow('mini CTS4 - Mask', mask)
                    
            
           


           
        key = 0xFF & cv2.waitKey(1)

                
        if key == 27:  # ESC  Key
                 break
        elif key == ord(' '):  # spacebar Key
                if View_select == 0:
                    View_select = 1
                
                else:
                    View_select = ArithmeticError
        


           


            

    # cleanup the camera and close any open windows
    if serial_use <> 0:
        serial_port.close()
    camera.release()
    cv2.destroyAllWindows()
    
