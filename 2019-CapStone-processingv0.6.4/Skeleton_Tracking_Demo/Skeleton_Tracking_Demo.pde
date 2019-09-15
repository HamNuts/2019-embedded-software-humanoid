import SimpleOpenNI.*;
//서버 통신
import processing.net.*;

Server c;
String data;
String status = "";

//Generate a SimpleOpenNI object
SimpleOpenNI kinect;

//Vectors used to calculate the center of the mass
PVector com = new PVector();
PVector com2d = new PVector();


//Up
float LeftshoulderAngle = 0;
float LeftelbowAngle = 0;
float RightshoulderAngle = 0;
float RightelbowAngle = 0;
float Firstarmth, FirstarmthL, Secondarmth, SecondarmthL, FirstKnee, SecondKnee, FirstKneeL, SecondKneeL;


//Legs
float RightLegAngle = 0;
float LeftLegAngle = 0;
float Waist = 0;
float WaistL = 0;


float armth = 0;
float armthl = 0;
//Timer variables
float a = 0;

//Number
//모션 캡쳐 변수 선언
int MotionNumber = 0;
//동작과 동작간의 변수 설정
int ExerciseNumber = 0;
// 시간 측정 변수 설정
int second = 0;
int oldsecond = 0;
int s;
//카운터 설정1
int counter = 0;
int oldcounter = 0;
//카운터 설정2
int CheckingNumber = 0;
int CheckMotion = 0;
//스켈레톤 함수 그리기 설정
int SkeletonMode = 1;
//Waiting 이미지를 구별해주기 위한 변수 추가
int WaitingNumber;

//운동 종류 변수 설정
int Kind = 0;
int Kind2 = 0;
//이미지 파일 변수 선언
PImage BackDumbingB;
PImage BackDumbingB_Complete;
PImage BackDumbingB_Warning;
PImage BackDumbingF;
PImage BackDumbingF_Complete;
PImage BackDumbingF_Warning;
PImage BackDumbing_Ready;
PImage Category;
PImage Default;
PImage ElepantNoseL;
PImage ElepantNoseL_Complete;
PImage ElepantNoseL_Warning;
PImage ElepantNoseR;
PImage ElepantNoseR_Complete;
PImage ElepantNoseR_Warning;
PImage HandsUp;
PImage HandsUp_Complete;
PImage HandsUp_Warning;
PImage InfraspinatusL;
PImage InfraspinatusL2;
PImage InfraspinatusL2_Complete;
PImage InfraspinatusL2_Warning;
PImage InfraspinatusL_Complete;
PImage InfraspinatusL_Warning;
PImage InfraspinatusR;
PImage InfraspinatusR2;
PImage InfraspinatusR2_Complete;
PImage InfraspinatusR2_Warning;
PImage InfraspinatusR_Complete;
PImage InfraspinatusR_Warning;
PImage LegextentionL;
PImage LegextentionL2;
PImage LegextentionL2_Complete;
PImage LegextentionL2_Warning;
PImage LegextentionL_Complete;
PImage LegextentionL_Warning;
PImage LegextentionR;
PImage LegextentionR2;
PImage LegextentionR2_Complete;
PImage LegextentionR2_Warning;
PImage LegextentionR_Complete;
PImage LegextentionR_Warning;
PImage LungeL;
PImage LungeL_Complete;
PImage LungeL_Ready;
PImage LungeL_Warning;
PImage LungeR;
PImage LungeR_Complete;
PImage LungeR_Ready;
PImage LungeR_Warning;
PImage QuadrateStretchingLReady;
PImage QuadrateStretchingLReady_Complete;
PImage QuadrateStretchingLReady_Warning;
PImage QuadrateStretchingL;
PImage QuadrateStretchingL_Complete;
PImage QuadrateStretchingL_Warning;
PImage QuadrateStretchingRReady;
PImage QuadrateStretchingRReady_Complete;
PImage QuadrateStretchingRReady_Warning;
PImage QuadrateStretchingR;
PImage QuadrateStretchingR_Complete;
PImage QuadrateStretchingR_Warning;
PImage ShoulderStretching;
PImage ShoulderStretching_Complete;
PImage ShoulderStretching_Warning;
PImage ShoulderStretching2;
PImage ShoulderStretching2_Complete;
PImage ShoulderStretching2_Warning;
PImage SpinaeStretching_Ready;
PImage SpinaeStretching;
PImage SpinaeStretching_Complete;
PImage SpinaeStretching_Warning;
PImage Squat;
PImage Squat_Complete;
PImage Squat_Ready;
PImage Squat_Warning;
PImage StandardS;
PImage StandardS_Complete;
PImage StandardS_Warning;
PImage StandardL;
PImage StandardL_Complete;
PImage StandardL_Warning;
PImage StandardW;
PImage StandardW_Complete;
PImage StandardW_Warning;
PImage Shoulder1_Waiting;
PImage Shoulder2_Waiting;
PImage Shoulder3_Waiting;
PImage Waist1_Waiting;
PImage Waist2_Waiting;
PImage Waist3_Waiting;
PImage Leg1_Waiting;
PImage Leg2_Waiting;
PImage Leg3_Waiting;
PImage Shoulder_END;
PImage Waist_END;
PImage Leg_END;




// 폰트 설정 변수 선언
PFont myFont;

int Height;
int Width;
int Sx;
int Sy;
double dH;
double dW;
/*
final int Height = 120; //1050
 final int Width  = 180; //1680
 //final float Sx = width*9.53/33.87;
 //final float Sy = height*3.84/19.05;
 final float Sx = 873;
 final float Sy = 351;
 //이종헌 test
 final float Height1 = 1056; //1050
 final float Width1  = 1438; //1680
 
 double dH = 0;
 double dW = 0;
 
 //영상 관련 변수
 
 final float Ex = 30;
 final float Ey = 160;
 
 final float Height2 = 480; //1050
 final float Width2  = 630; //1680
 */

//final int INIT = 0;
//final int MID = 1;
//final int LEFT = 2;

void SetScale(int mode) {
  if (mode == 0) {
    Height = height;
    Width  = width;
    dH     = dW = 0.0;
    Sx     = Sy = 0;
  } else if (mode == 1) {
    Width = (int)(15 / 33.87 * width);
    //       Width = (int)(863.0 * width / 1920.0);
    Height  = (int)(634.0 / 1080.0 * height);
    Sy     = (int)(height * 3.84 / 19.05);
    Sx     = (int)(width * 9.53 / 33.87);
  } else if (mode == 2) {
    //width : 26.84 + (6.68) + 0.35
    //height : 12.4 + (4.89) + 1.76
    Width = (int)(6.68 / 33.87 * width);
    Height = (int)(4.89 / 19.05 * height);
    Sy     = (int)(1.76 / 19.05 * height);
    Sx     = (int)(0.35 / 33.87 * width);
  }
  dW = (double)Width / 640;
  dH = (double)Height / 480;
}

//글씨 변수 선언

//height : 5.82 + 11.51 - 19.05
//width : 15.66 + 16.73 - 33.87
int secondx = 1543;//1543
int secondy = (int)((11.51) / 19.05 * height); //1180
int chox = (int)((16.73) / 33.87 * width);//1600
int motionx = 2722;
int motiony = 1550;  
int totalx = 2800;


void setup() {
  secondy = (int)((11.51) / 19.05 * height * 1080 / height); //1180
  chox = (int)((16.73) / 33.87 * width);
  //println(width,height,Height1,Width1,Sx,Sy);
  //텍스트 부분
  myFont = createFont("BMJUA_ttf.ttf", 80);

  //서버 통신 부분
  c = new Server(this, 1234);
  // 이미지 선언 부분
  /*
  PImage List[] = new PImage[1000];
   final int ImageCnt = 100; 
   for(int i=0;i<ImageCnt;i++){
   List[i] = loadImage("silde"+i+".PNG");
   }
   
   ...
   
   python2, 3 => 노가다
   ...
   */
  BackDumbingB= loadImage("BackDumbingB.PNG");
  BackDumbingB_Complete= loadImage("BackDumbingB_Complete.PNG");
  BackDumbingB_Warning= loadImage("BackDumbingB_Warning.PNG");
  BackDumbingF= loadImage("BackDumbingF.PNG");
  BackDumbingF_Complete= loadImage("BackDumbingF_Complete.PNG");
  BackDumbingF_Warning= loadImage("BackDumbingF_Warning.PNG");
  BackDumbing_Ready= loadImage("BackDumbing_Ready.PNG");
  Category= loadImage("Category.PNG");
  Default= loadImage("Default.PNG");
  ElepantNoseL= loadImage("ElepantNoseL.PNG");
  ElepantNoseL_Complete= loadImage("ElepantNoseL_Complete.PNG");
  ElepantNoseL_Warning= loadImage("ElepantNoseL_Warning.PNG");
  ElepantNoseR= loadImage("ElepantNoseR.PNG");
  ElepantNoseR_Complete= loadImage("ElepantNoseR_Complete.PNG");
  ElepantNoseR_Warning= loadImage("ElepantNoseR_Warning.PNG");
  HandsUp= loadImage("HandsUp.PNG");
  HandsUp_Complete= loadImage("HandsUp_Complete.PNG");
  HandsUp_Warning= loadImage("HandsUp_Warning.PNG");
  InfraspinatusL= loadImage("InfraspinatusL.PNG");
  InfraspinatusL2= loadImage("InfraspinatusL2.PNG");
  InfraspinatusL2_Complete= loadImage("InfraspinatusL2_Complete.PNG");
  InfraspinatusL2_Warning= loadImage("InfraspinatusL2_Warning.PNG");
  InfraspinatusL_Complete= loadImage("InfraspinatusL_Complete.PNG");
  InfraspinatusL_Warning= loadImage("InfraspinatusL_Warning.PNG");
  InfraspinatusR= loadImage("InfraspinatusR.PNG");
  InfraspinatusR2= loadImage("InfraspinatusR2.PNG");
  InfraspinatusR2_Complete= loadImage("InfraspinatusR2_Complete.PNG");
  InfraspinatusR2_Warning= loadImage("InfraspinatusR2_Warning.PNG");
  InfraspinatusR_Complete= loadImage("InfraspinatusR_Complete.PNG");
  InfraspinatusR_Warning= loadImage("InfraspinatusR_Warning.PNG");
  LegextentionL= loadImage("LegextentionL.PNG");
  LegextentionL2= loadImage("LegextentionL2.PNG");
  LegextentionL2_Complete= loadImage("LegextentionL2_Complete.PNG");
  LegextentionL2_Warning= loadImage("LegextentionL2_Warning.PNG");
  LegextentionL_Complete= loadImage("LegextentionL_Complete.PNG");
  LegextentionL_Warning= loadImage("LegextentionL_Warning.PNG");
  LegextentionR= loadImage("LegextentionR.PNG");
  LegextentionR2= loadImage("LegextentionR2.PNG");
  LegextentionR2_Complete= loadImage("LegextentionR2_Complete.PNG");
  LegextentionR2_Warning= loadImage("LegextentionR2_Warning.PNG");
  LegextentionR_Complete= loadImage("LegextentionR_Complete.PNG");
  LegextentionR_Warning= loadImage("LegextentionR_Warning.PNG");
  LungeL= loadImage("LungeL.PNG");
  LungeL_Complete= loadImage("LungeL_Complete.PNG");
  LungeL_Ready= loadImage("LungeL_Ready.PNG");
  LungeL_Warning= loadImage("LungeL_Warning.PNG");
  LungeR= loadImage("LungeR.PNG");
  LungeR_Complete= loadImage("LungeR_Complete.PNG");
  LungeR_Ready= loadImage("LungeR_Ready.PNG");
  LungeR_Warning= loadImage("LungeR_Warning.PNG");
  QuadrateStretchingLReady = loadImage("QuadrateStretchingLReady.PNG");
  QuadrateStretchingLReady_Complete = loadImage("QuadrateStretchingLReady_Complete.PNG");
  QuadrateStretchingLReady_Warning = loadImage("QuadrateStretchingLReady_Warning.PNG");
  QuadrateStretchingL= loadImage("QuadrateStretchingL.PNG");
  QuadrateStretchingL_Complete= loadImage("QuadrateStretchingL_Complete.PNG");
  QuadrateStretchingL_Warning= loadImage("QuadrateStretchingL_Warning.PNG");
  QuadrateStretchingRReady = loadImage("QuadrateStretchingRReady.PNG");
  QuadrateStretchingRReady_Complete = loadImage("QuadrateStretchingRReady_Complete.PNG");
  QuadrateStretchingRReady_Warning = loadImage("QuadrateStretchingRReady_Warning.PNG");
  QuadrateStretchingR= loadImage("QuadrateStretchingR.PNG");
  QuadrateStretchingR_Complete= loadImage("QuadrateStretchingR_Complete.PNG");
  QuadrateStretchingR_Warning = loadImage("QuadrateStretchingR_Warning .PNG");
  ShoulderStretching= loadImage("ShoulderStretching.PNG");
  ShoulderStretching_Complete = loadImage("ShoulderStretching_Complete.PNG");
  ShoulderStretching_Warning = loadImage("ShoulderStretching_Warning.PNG");
  ShoulderStretching2= loadImage("ShoulderStretching2.PNG");
  ShoulderStretching2_Complete= loadImage("ShoulderStretching2_Complete.PNG");
  ShoulderStretching2_Warning= loadImage("ShoulderStretching2_Warning.PNG");
  SpinaeStretching_Ready= loadImage("SpinaeStretching_Ready.PNG");
  SpinaeStretching= loadImage("SpinaeStretching.PNG");
  SpinaeStretching_Complete= loadImage("SpinaeStretching_Complete.PNG");
  SpinaeStretching_Warning= loadImage("SpinaeStretching_Warning.PNG");
  Squat= loadImage("Squat.PNG");
  Squat_Complete= loadImage("Squat_Complete.PNG");
  Squat_Ready= loadImage("Squat_Ready.PNG");
  Squat_Warning= loadImage("Squat_Warning.PNG");
  StandardS= loadImage("StandardS.PNG");
  StandardS_Complete= loadImage("StandardS_Complete.PNG");
  StandardS_Warning= loadImage("StandardS_Warning.PNG");
  StandardL= loadImage("StandardL.PNG");
  StandardL_Complete= loadImage("StandardL_Complete.PNG");
  StandardL_Warning= loadImage("StandardL_Warning.PNG");
  StandardW= loadImage("StandardW.PNG");
  StandardW_Complete= loadImage("StandardW_Complete.PNG");
  StandardW_Warning= loadImage("StandardW_Warning.PNG");
  Shoulder1_Waiting = loadImage("Shoulder1_Waiting.PNG");
  Shoulder2_Waiting = loadImage("Shoulder2_Waiting.PNG");
  Shoulder3_Waiting = loadImage("Shoulder3_Waiting.PNG");
  Waist1_Waiting = loadImage("Waist1_Waiting.PNG");
  Waist2_Waiting = loadImage("Waist3_Waiting.PNG");
  Waist3_Waiting = loadImage("Waist3_Waiting.PNG");
  Leg1_Waiting = loadImage("Leg1_Waiting.PNG");
  Leg2_Waiting = loadImage("Leg2_Waiting.PNG");
  Leg3_Waiting = loadImage("Leg3_Waiting.PNG");
  Shoulder_END = loadImage("Shoulder_END.PNG");
  Waist_END = loadImage("Waist_END.PNG");
  Leg_END = loadImage("Leg_END.PNG");

  // 이미지 선언 끝

  //size(1280, 960); // backgrownd size (640,480)
  fullScreen();
  SetScale(0);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  //kinect.enableIR();
  kinect.setMirror(true);
  kinect.enableUser();// because of the version this change
  //size(640, 480);
  fill(255, 0, 0);
  //size(kinect.depthWidth()+kinect.irWidth(), kinect.depthHeight());

  image(Default, 0, 0, width, height);
}

void draw() {

  textFont(myFont);
  kinect.update();
  //clear();
  //image(kinect.depthImage(), 0, 0);
  //image(kinect.irImage(),kinect.depthWidth(),0);
  SetScale(1);
  image(Default, 0, 0, width, height);

  image(kinect.userImage(), Sx, Sy, Width, Height);
  //image(kinect.userImage(), 0, 0, 1280, 960); //image size-----------
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) { 
    int userId = userList.get(0);
    //If we detect one user we have to draw it
    if (userId == 1 && kinect.isTrackingSkeleton(userId)) {
      //DrawSkeleton
      serverC();
      //ShoulderExercise();
      if (SkeletonMode == 1) {
        drawSkeleton(userId);
      }
      //drawUpAngles
      ArmsAngle(userId);
      //Draw the user Mass
      MassUser(userId);
      //AngleLeg
      LegsAngle(userId);
    }
  }
  fill(255, 0, 0);
}
// 서버 통신 함수
void serverC() {
  Client thisClient = c.available();
  if (thisClient != null) {
    String server_message = thisClient.readString();     // 서버 메시지
    println(server_message);
    status = server_message;
    if (server_message.equals("categoryMode")) {            // 
      println("success");
      SkeletonMode = 0;
      image(Category, 0, 0, width, height);
    }
    if (server_message.equals("Shoulder1")) {            // 
      println("success");
      SkeletonMode = 1;
      WaitingNumber = 1;
      shoulder1();
    }
    if (server_message.equals("Shoulder2")) {            // 
      println("success");
      SkeletonMode = 1;
      WaitingNumber = 2;
      shoulder2();
    }
    if (server_message.equals("Shoulder3")) {            // 
      println("success");
      WaitingNumber = 3;
      SkeletonMode = 1;
      shoulder3();
    }       
    if (server_message.equals("Waist1")) {            // 
      println("success");
      WaitingNumber = 1;
      SkeletonMode = 1;
      waist1();
    }
    if (server_message.equals("Waist2")) {            // 
      println("success");
      WaitingNumber = 2;
      SkeletonMode = 1;
      waist2();
    }
    if (server_message.equals("Waist3")) {            // 
      println("success");
      WaitingNumber = 3;
      SkeletonMode = 1;
      waist3();
    }
    if (server_message.equals("Leg1")) {            // 
      println("success");
      WaitingNumber = 1;
      SkeletonMode = 1;
      leg1();
    }
    if (server_message.equals("Leg2")) {            // 
      println("success");
      WaitingNumber = 2;
      SkeletonMode = 1;
      leg2();
    }
    if (server_message.equals("Leg3")) {            // 
      println("success");
      WaitingNumber = 3;
      SkeletonMode = 1;
      leg3();
    }
  } else {
    if (status.equals("categoryMode")) {            // 
      println("success");
      SkeletonMode = 0;
      image(Category, 0, 0, width, height);
    }
    if (status.equals("Shoulder1")) {            // 
      println("success");
      SkeletonMode = 1;
      shoulder1();
    }
    if (status.equals("Shoulder2")) {            // 
      println("success");
      SkeletonMode = 1;
      shoulder2();
    }
    if (status.equals("Shoulder3")) {            // 
      println("success");
      SkeletonMode = 1;
      shoulder3();
    }       
    if (status.equals("Waist1")) {            // 
      println("success");
      SkeletonMode = 1;
      waist1();
    }
    if (status.equals("Waist2")) {            // 
      println("success");
      SkeletonMode = 1;
      waist2();
    }
    if (status.equals("Waist3")) {            // 
      println("success");
      SkeletonMode = 1;
      waist3();
    }
    if (status.equals("Leg1")) {            // 
      println("success");
      SkeletonMode = 1;
      leg1();
    }
    if (status.equals("Leg2")) {            // 
      println("success");
      SkeletonMode = 1;
      leg2();
    }
    if (status.equals("Leg3")) {            // 
      println("success");
      SkeletonMode = 1;
      leg3();
    }
  }
}





//Draw the skeleton
void drawSkeleton(int userId) {

  fill(255, 0, 0);
  drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
  stroke(0);
  strokeWeight(5);
  DrawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  DrawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  DrawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  DrawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  DrawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
  DrawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  DrawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_SHOULDER);

  noStroke();
}

void DrawLimb(int userId, int a, int b) {
  PVector joint1 = new PVector();
  PVector joint2 = new PVector();

  float confidence = kinect.getJointPositionSkeleton(userId, a, joint1);
  if (confidence < 0.5)return;
  confidence = kinect.getJointPositionSkeleton(userId, b, joint2);
  if (confidence < 0.5)return;
  PVector A = new PVector();
  PVector B = new PVector();
  kinect.convertRealWorldToProjective(joint1, A);
  kinect.convertRealWorldToProjective(joint2, B);
  line((int)(Sx + A.x * dW), (int)(Sy + A.y * dH), (int)(Sx + dW * B.x), (int)(Sy + dH *B.y));
}

void drawJoint(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = kinect.getJointPositionSkeleton(userId, jointID, 
    joint);
  if (confidence < 0.5) {
    return;
  }
  PVector convertedJoint = new PVector();
  kinect.convertRealWorldToProjective(joint, convertedJoint);
  ellipse(Sx + (int)(convertedJoint.x * dW), Sy + (int)(convertedJoint.y * dH), 5, 5);
}
//Generate the angle
float angleOf(PVector one, PVector two, PVector axis) {
  PVector limb = PVector.sub(two, one);
  return degrees(PVector.angleBetween(limb, axis));
}

//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

void MassUser(int userId) {
  if (kinect.getCoM(userId, com)) {
    kinect.convertRealWorldToProjective(com, com2d);
    stroke(100, 255, 240);
    strokeWeight(1);
    beginShape(LINES);
    vertex(Sx + (int)(com2d.x * dW), Sy + (int)(com2d.y * dH) - 2);
    vertex(Sx + (int)(com2d.x * dW), Sy + (int)(com2d.y * dH) + 2);
    vertex(Sx + (int)(com2d.x * dW) - 2, Sy + (int)(com2d.y * dH));
    vertex(Sx + (int)(com2d.x * dW) + 2, Sy + (int)(com2d.y * dH));
    endShape();
    fill(0, 255, 100);
    //text(Integer.toString(userId), com2d.x, com2d.y);
  }
}

public void ArmsAngle(int userId) {
  // get the positions of the three joints of our right arm
  PVector rightHand = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
  PVector rightElbow = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);
  PVector rightShoulder = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
  // we need right hip to orient the shoulder angle
  PVector rightHip = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);
  // get the positions of the three joints of our left arm
  PVector leftHand = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
  PVector leftElbow = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, leftElbow);
  PVector leftShoulder = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
  // we need left hip to orient the shoulder angle
  PVector leftHip = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, leftHip);
  // reduce our joint vectors to two dimensions for right side
  PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
  PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
  PVector rightShoulder2D = new PVector(rightShoulder.x, rightShoulder.y);
  PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
  // calculate the axes against which we want to measure our angles
  PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
  PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);
  PVector ArmtoHand = PVector.sub(rightHand2D, rightElbow2D);
  // reduce our joint vectors to two dimensions for left side
  PVector leftHand2D = new PVector(leftHand.x, leftHand.y);
  PVector leftElbow2D = new PVector(leftElbow.x, leftElbow.y);
  PVector leftShoulder2D = new PVector(leftShoulder.x, leftShoulder.y);
  PVector leftHip2D = new PVector(leftHip.x, leftHip.y);
  // calculate the axes against which we want to measure our angles
  PVector torsoLOrientation = PVector.sub(leftShoulder2D, leftHip2D);
  PVector upperArmLOrientation = PVector.sub(leftElbow2D, leftShoulder2D);
  PVector ArmtoHandL = PVector.sub(leftHand2D, leftElbow2D);
  Secondarmth = degrees(ArmtoHand.heading());
  SecondarmthL = degrees(ArmtoHandL.heading());
  Firstarmth = degrees(upperArmOrientation.heading());
  FirstarmthL = degrees(upperArmLOrientation.heading());

  // calculate the angles between our joints for rightside
  RightshoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
  RightelbowAngle = angleOf(rightHand2D, rightElbow2D, upperArmOrientation);
  // show the angles on the screen for debugging
  fill(255, 0, 0);
  //scale(4);
  //text(" 오른팔1: " + degrees(upperArmOrientation.heading()) + "\n" + "오른팔2: "+ degrees(ArmtoHand.heading()), 20, 20);

  // calculate the angles between our joints for leftside
  LeftshoulderAngle = angleOf(leftElbow2D, leftShoulder2D, torsoLOrientation);
  LeftelbowAngle = angleOf(leftHand2D, leftElbow2D, upperArmLOrientation);
  // show the angles on the screen for debugging
  fill(255, 0, 0);
  //scale(2);
  //text(" 왼팔1 : " + degrees(upperArmLOrientation.heading()) + "\n" + "왼팔2 : "+ degrees(ArmtoHandL.heading()), 20, 70);
}

void LegsAngle(int userId) {
  PVector rightShoulder = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
  PVector rightShoulder2D = new PVector(rightShoulder.x, rightShoulder.y);

  PVector leftShoulder = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
  PVector leftShoulder2D = new PVector(leftShoulder.x, leftShoulder.y);
  // get the positions of the three joints of our right leg
  PVector rightFoot = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);
  PVector rightKnee = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, rightKnee);
  PVector rightHipL = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, rightHipL);
  // reduce our joint vectors to two dimensions for right side
  PVector rightFoot2D = new PVector(rightFoot.x, rightFoot.y);
  PVector rightKnee2D = new PVector(rightKnee.x, rightKnee.y);
  PVector rightHip2DLeg = new PVector(rightHipL.x, rightHipL.y);
  // calculate the axes against which we want to measure our angles
  PVector RightLegOrientation = PVector.sub(rightKnee2D, rightHip2DLeg);
  PVector RightFootOrientation = PVector.sub(rightFoot2D, rightKnee2D);
  PVector RightWaist = PVector.sub(rightHip2DLeg, rightShoulder2D);
  // calculate the angles between our joints for rightside
  RightLegAngle = angleOf(rightFoot2D, rightKnee2D, RightLegOrientation);
  fill(255, 0, 0);
  scale(1);
  //text("오른다리: " + FirstKnee + "\n" + "오른다리: "+ SecondKnee + "\n" + "허리" + WaistL, 20, 120);
  // get the positions of the three joints of our left leg
  PVector leftFoot = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, leftFoot);
  PVector leftKnee = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, leftKnee);
  PVector leftHipL = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, leftHipL);
  // reduce our joint vectors to two dimensions for left side
  PVector leftFoot2D = new PVector(leftFoot.x, leftFoot.y);
  PVector leftKnee2D = new PVector(leftKnee.x, leftKnee.y);
  PVector leftHip2DLeg = new PVector(leftHipL.x, leftHipL.y);
  // calculate the axes against which we want to measure our angles
  PVector LeftLegOrientation = PVector.sub(leftKnee2D, leftHip2DLeg);
  // calculate the angles between our joints for left side
  LeftLegAngle = angleOf(leftFoot2D, leftKnee2D, LeftLegOrientation);
  PVector LeftFootOrientation = PVector.sub(leftFoot2D, leftKnee2D);
  PVector LeftWaist = PVector.sub(leftHip2DLeg, leftShoulder2D);
  FirstKnee = degrees(RightLegOrientation.heading());
  SecondKnee = degrees(RightFootOrientation.heading());
  FirstKneeL = degrees(LeftLegOrientation.heading());
  SecondKneeL = degrees(LeftFootOrientation.heading());
  Waist = degrees(RightWaist.heading());
  WaistL = degrees(LeftWaist.heading());
  // show the angles on the screen for debugging

  fill(255, 0, 0);
  scale(1);
  //text("왼다리1: " + FirstKneeL +"\n" + "왼다리2: "+ SecondKneeL + "\n" + "허리" + WaistL, 20, 170);
}
/*
void assemble(int userId){
 
 //drawUpAngles
 ArmsAngle(userId);
 
 //AngleLeg
 LegsAngle(userId);
 println(int(RightshoulderAngle));
 
 }*/
//카운터 함수
void counter() {
  second = second();
  if (second != oldsecond) {
    counter += 1;
    CheckingNumber += 1;
  }
  oldsecond = second;
}

void Standard() {
  counter();
  if (MotionNumber<25) {
    if ((Firstarmth>-105&&Firstarmth<-60)&&(Secondarmth>-115&&Secondarmth<-65)&&(FirstarmthL>-125&&FirstarmthL<-75)&&(SecondarmthL>-115&&SecondarmthL<-65)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("차렷!");
      if (Kind == 1) {
        image(StandardW, 0, 0, width, height);
      } else if (Kind == 2) {
        image(StandardL, 0, 0, width, height);
      } else {
        image(StandardS, 0, 0, width, height);
      }
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("차렷! 탐색중....("+MotionNumber+"/25)");
      if (Kind == 1) {
        image(StandardW, 0, 0, width, height);
      } else if (Kind == 2) {
        image(StandardL, 0, 0, width, height);
      } else {
        image(StandardS, 0, 0, width, height);
      }
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {

        println("자세 교정이 필요합니다!!!");
        if (Kind == 1) {
          image(StandardW_Warning, 0, 0, width, height);
        } else if (Kind == 2) {
          image(StandardL_Warning, 0, 0, width, height);
        } else {
          image(StandardS_Warning, 0, 0, width, height);
        }
      }
    }
  } else {
    if (Kind == 1) {
      image(StandardW_Complete, 0, 0, width, height);
    } else if (Kind == 2) {
      image(StandardL_Complete, 0, 0, width, height);
    } else {
      image(StandardS_Complete, 0, 0, width, height);
    }
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2);
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void HandsUp() {
  counter();
  if (MotionNumber<20) {
    if ((Firstarmth>40&&Firstarmth<110)&&(Secondarmth>45&&Secondarmth<110)&&(FirstarmthL>50&&FirstarmthL<130)&&(SecondarmthL>50&&SecondarmthL<130)) {
      println("\\^0^/");
      image(HandsUp, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("손들기 탐색중....("+MotionNumber+"/20)");
      image(HandsUp, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        image(HandsUp_Warning, 0, 0, width, height);
        println("자세 교정이 필요합니다!!!");
      }
    }
  } else {
    image(HandsUp_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {

      println("완료");
      MotionNumber = 0;

      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  SetScale(2);
  image(kinect.userImage(), Sx, Sy, Width, Height);
  text(MotionNumber, motionx, motiony);
  text("/20", totalx, motiony);
}


void ElepantNose1() {
  counter();
  if (MotionNumber<15) {
    if ((Firstarmth>-90&&Firstarmth<10)&&(Secondarmth>70&&Secondarmth<110)&&(FirstarmthL>-20&&FirstarmthL<20)&&(SecondarmthL>-20&&SecondarmthL<20)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("0(^0^)==0");
      image(ElepantNoseL, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      image(ElepantNoseL, 0, 0, width, height);
      println("ElepantNose 탐색중....("+MotionNumber+"/15)");
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        image(ElepantNoseL_Warning, 0, 0, width, height);
        println("자세 교정이 필요합니다!!!");
      }
    }
  } else {
    image(ElepantNoseL_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
      oldcounter = 0;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);

      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/15", totalx, motiony);
  SetScale(2);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void ElepantNose2() {
  counter();
  if (MotionNumber<15) {
    if ((Firstarmth>-200&&Firstarmth<-160)&&(Secondarmth>160||Secondarmth<-160)&&(FirstarmthL>-160&&FirstarmthL<-105)&&(SecondarmthL<110&&SecondarmthL>70)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("0(^0^)==0");
      image(ElepantNoseR, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("코끼리코2 탐색중...("+MotionNumber+"/15)");
      image(ElepantNoseR, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(ElepantNoseR_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(ElepantNoseR_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {

      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/15", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void ShoulderStretching() {
  counter();
  if (MotionNumber<40) {
    //Youtube 6:30
    if ((Firstarmth>-10||Firstarmth<10)&&(Secondarmth>70&&Secondarmth<100)&&(FirstarmthL>-180&&FirstarmthL<-160)&&(SecondarmthL>70&&SecondarmthL<100)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("ShoulderStretching!");
      image(ShoulderStretching, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("ShoulderStretching 탐색중....("+MotionNumber+"/40)");
      image(ShoulderStretching, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(ShoulderStretching_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(ShoulderStretching_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/40", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void ShoulderStretching2() {
  counter();
  if (MotionNumber<10) {
    //Youtube 6:30
    if ((Firstarmth>-10||Firstarmth<10)&&(Secondarmth>70&&Secondarmth<100)&&(FirstarmthL>-180&&FirstarmthL<-160)&&(SecondarmthL>70&&SecondarmthL<100)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("ShoulderStretching!");
      image(ShoulderStretching2, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("ShoulderStretching 탐색중....("+MotionNumber+"/10)");
      image(ShoulderStretching, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(ShoulderStretching2_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(ShoulderStretching2_Complete, 0, 0, width, height);
    if (counter - oldcounter == 3) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/10", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void InfraspinatusR() {
  counter();
  if (MotionNumber<25) {
    if ((Firstarmth>-80&&Firstarmth<-30)&&(Secondarmth>-160&&Secondarmth<-80)&&(FirstarmthL>-150&&FirstarmthL<-80)&&(SecondarmthL>-150&&SecondarmthL<-80)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("Infraspintus3!");
      if (Kind2==0) {
        image(InfraspinatusR, 0, 0, width, height);
      } else {
        image(QuadrateStretchingRReady, 0, 0, width, height);
      }
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Infraspintus3 탐색중....("+MotionNumber+"/25)");
      if (Kind2==0) {
        image(InfraspinatusR, 0, 0, width, height);
      } else {
        image(QuadrateStretchingRReady, 0, 0, width, height);
      }

      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        if (Kind2==0) {
          image(InfraspinatusR_Warning, 0, 0, width, height);
        } else {
          image(QuadrateStretchingRReady_Warning, 0, 0, width, height);
        }
      }
    }
  } else {
    if (Kind2==0) {
      image(InfraspinatusR_Complete, 0, 0, width, height);
    } else {
      image(QuadrateStretchingRReady_Complete, 0, 0, width, height);
    }
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void InfraspinatusL() {
  counter();
  if (MotionNumber<25) {
    if ((Firstarmth>-90&&Firstarmth<-30)&&(Secondarmth>-90&&Secondarmth<-30)&&(FirstarmthL>-150&&FirstarmthL<-110)&&(SecondarmthL>-80&&SecondarmthL<-40)) {
      println("Infraspintus3!");
      if (Kind2==0) {
        image(InfraspinatusL, 0, 0, width, height);
      } else {
        image(QuadrateStretchingLReady, 0, 0, width, height);
      }
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Infraspintus3 탐색중....("+MotionNumber+"/45)");
      if (Kind2== 0) {
        image(InfraspinatusL, 0, 0, width, height);
      } else {
        image(QuadrateStretchingLReady, 0, 0, width, height);
      }
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        if (Kind2== 0) {
          image(InfraspinatusL, 0, 0, width, height);
        } else {
          image(QuadrateStretchingLReady, 0, 0, width, height);
        }
      }
    }
  } else {
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void InfraspinatusR2() {
  counter();
  if (MotionNumber<25) {
    if ((Firstarmth>-80&&Firstarmth<-30)&&(Secondarmth>-160&&Secondarmth<-80)&&(FirstarmthL>-100&&FirstarmthL<-50)&&(SecondarmthL>-20||SecondarmthL<20)) {
      println("Infraspintus2!");
      image(InfraspinatusR2, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Infraspintus2 탐색중....("+MotionNumber+"/5)");
      image(InfraspinatusR2, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(InfraspinatusR2_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(InfraspinatusR2_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void InfraspinatusL2() {
  counter();
  if (MotionNumber<25) {
    if ((Firstarmth>-160&&Firstarmth<-110)&&(Secondarmth>160||Secondarmth<-160)&&(FirstarmthL>-150&&FirstarmthL<-100)&&(SecondarmthL>-70&&SecondarmthL<-30)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)) {
      println("Infraspintus6!");
      image(InfraspinatusL2, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Infraspintus6 탐색중....("+MotionNumber+"/25)");
      image(InfraspinatusL2, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(InfraspinatusL2_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(InfraspinatusL2_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void LegextentionL() {
  counter();
  if (MotionNumber<30) {
    if ((FirstKnee>-110&&FirstKnee<-70)&&(SecondKnee>-120&&SecondKnee<-60)&&(FirstKneeL>-160&&FirstKneeL<-120)&&(SecondKneeL>-105&&SecondKneeL<-65)) {
      println("Legextention1");
      image(LegextentionL, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Legextention1 탐색중....("+MotionNumber+"/30)");
      image(LegextentionL, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(LegextentionL_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(LegextentionL_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/30", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void LegextentionL2() {
  counter();
  if (MotionNumber<25) {
    if ((FirstKneeL>-165&&FirstKneeL<-125)&&(SecondKneeL>-150&&SecondKneeL<-110)) {
      println("Legextention2");
      image(LegextentionL2, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Legextention2 탐색중....("+MotionNumber+"/25)");
      image(LegextentionL2, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(LegextentionL2_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(LegextentionL2_Complete, 0, 0, width, height);   
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void LegextentionR() {
  counter();
  if (MotionNumber<30) {
    if ((FirstKnee>-55&&FirstKnee<-15)&&(SecondKnee>-120&&SecondKnee<-60)&&(FirstKneeL>-130&&FirstKneeL<-70)&&(SecondKneeL>-130&&SecondKneeL<-60)) {
      println("Legextention3");
      image(LegextentionR, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Legextention3 탐색중....("+MotionNumber+"/30)");
      image(LegextentionR, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(LegextentionR_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(LegextentionR_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/30", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void LegextentionR2() {
  counter();
  if (MotionNumber<25) {
    if ((FirstKnee>-65&&FirstKnee<-30)&&(SecondKnee>-75&&SecondKnee<-25)&&(FirstKneeL>-130&&FirstKneeL<-70)&&(SecondKneeL>-120&&SecondKneeL<-60)) {
      println("Legextention4");
      image(LegextentionR2, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Legextention4 탐색중....("+MotionNumber+"/25)");
      image(LegextentionR2, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(LegextentionR2_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(LegextentionR2_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/25", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void LungeLReady() {
  counter();
  if (CheckingNumber<5) {
    println("몸을 측면으로 향하고 5초간 기다려주세요");
    image(LungeL_Ready, 0, 0, width, height);
    text(CheckingNumber, 780, 430);
    text("초", 790, 430);
  } else {
    ExerciseNumber +=1;
    CheckingNumber = 0;
  }

  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void LungeL() {
  counter();
  if (MotionNumber<20) {
    if ((FirstKneeL>-170&&FirstKneeL<-145)&&(SecondKneeL>-105&&SecondKneeL<-75)) {
      println("Lunge1");
      image(LungeL, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Lunge1 탐색중....("+MotionNumber+"/20)");
      image(LungeL, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(LungeL_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(LungeL_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/20", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void LungeRReady() {
  counter();
  if (CheckingNumber<5) {
    println("몸을 측면으로 향하고 5초간 기다려주세요");
    image(LungeR_Ready, 0, 0, width, height);
    text(CheckingNumber, 780, 430);
    text("초", 790, 430);
  } else {
    ExerciseNumber +=1;
    CheckingNumber = 0;
  }
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void LungeR() {
  counter();
  if (MotionNumber<20) {
    if ((FirstKnee>-35&&FirstKnee<0)&&(SecondKnee>-105&&SecondKnee<-75)) {
      println("Lunge2");
      image(LungeR, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Lunge2 탐색중....("+MotionNumber+"/20)");
      image(LungeR, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(LungeR_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(LungeR_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/20", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void QuadrateStretchingL() {
  counter();
  if (MotionNumber<20) {
    if ((Firstarmth>60&&Firstarmth<130)&&(Secondarmth>100&&Secondarmth<160)&&(Waist>-70&&Waist<-30)) {
      println("QuadrateStretching");
      image(QuadrateStretchingL, 0, 0, width, height);
      MotionNumber +=1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("QuadrateStretching 탐색중....("+MotionNumber+"/20)");
      image(QuadrateStretchingL, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(QuadrateStretchingL_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(QuadrateStretchingL_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/20", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void QuadrateStretchingR() {
  counter();
  if (MotionNumber<20) {   
    if ((FirstarmthL>50&&FirstarmthL<130)&&(SecondarmthL>0&&SecondarmthL<70)&&(Waist>-170&&Waist<-80)) {
      println("QuadrateStretching2"+MotionNumber);
      image(QuadrateStretchingR, 0, 0, width, height);
      MotionNumber +=1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("QuadrateStretching2 탐색중.....("+MotionNumber+"/20)");
      image(QuadrateStretchingR, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(QuadrateStretchingR_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(QuadrateStretchingR_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/20", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void ErectorSpinaeStretching() {
  counter();
  if (MotionNumber<30) {
    if ((Firstarmth>-80&&Firstarmth<-30)&&(Secondarmth>-160&&Secondarmth<-80)&&(FirstarmthL>-120&&FirstarmthL<-80)&&(SecondarmthL>-120&&SecondarmthL<-80)&&(FirstKnee>-100&&FirstKnee<-60)&&(SecondKnee>-110&&SecondKnee<-70)&&(FirstKneeL>-120&&FirstKneeL<-80)&&(SecondKneeL>-110&&SecondKneeL<-70)) {
      println("ErectorSpinaeStretching");
      image(QuadrateStretchingL_Complete, 0, 0, width, height);
      MotionNumber +=1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("ErectorSpinaeStretching 탐색중.....("+MotionNumber+"/30)");
      image(QuadrateStretchingL_Complete, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(QuadrateStretchingL_Complete, 0, 0, width, height);
      }
    }
  } else {
    image(QuadrateStretchingL_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/30", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void BackDumbingReady() {
  counter();
  if (CheckingNumber<5) {
    println("몸을 측면으로 향하고 5초간 기다려주세요");
    image(BackDumbing_Ready, 0, 0, width, height);
    text("초", 790, 430);
    text(CheckingNumber, 780, 430);
  } else {

    ExerciseNumber +=1;
    CheckingNumber = 0;
  }

  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void BackDumbing2() {
  counter();
  if (MotionNumber<30) {
    if ((Waist<-130 && Waist<-110)) {
      println("BackDumbing");
      image(BackDumbingF, 0, 0, width, height);
      MotionNumber +=1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("BackDumbing 탐색중.....("+MotionNumber+"/30)");
      image(BackDumbingF, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(BackDumbingF_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(BackDumbingF_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/30", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void BackDumbing() {
  counter();
  if (MotionNumber<30) {
    if ((-60 < Waist && Waist<20)) {
      println("BackDumbing2");
      image(BackDumbingB, 0, 0, width, height);
      MotionNumber +=1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("BackDumbing 탐색중.....("+MotionNumber+"/30)");
      image(BackDumbingB, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(BackDumbingB_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(BackDumbingB_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }

  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void SpinaeStretchingReady() {
  counter();
  if (CheckingNumber<5) {
    println("양팔을 뻗어  5초간 기다려주세요");
    image(SpinaeStretching_Ready, 0, 0, width, height);
    text(CheckingNumber, 780, 430);
    text("초", 790, 430);
  } else {
    ExerciseNumber+=1;
    CheckingNumber = 0;
  }

  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void SpinaeStretching() {
  counter();
  if (MotionNumber<30) {
    if ((Firstarmth>-100&&Firstarmth<-60)&&(Secondarmth>-150&&Secondarmth<-110)&&(FirstarmthL>-120&&FirstarmthL<-80)&&(SecondarmthL>-80&&SecondarmthL<-40)&&(FirstKnee>-80&&FirstKnee<-40)&&(FirstKneeL>-140&&FirstKneeL<-100)) {
      println("SpinaeStretching!");
      image(SpinaeStretching, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("SpinaeStretching 탐색중....("+MotionNumber+"/30)");
      image(SpinaeStretching, 0, 0, width, height);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(SpinaeStretching_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(SpinaeStretching_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/30", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void SquatReady() {
  counter();
  if (CheckingNumber<5) {
    println("양팔을 뻗어  5초간 기다려주세요");
    image(Squat_Ready, 0, 0, width, height);
    text(CheckingNumber, 780, 430);
    text("초", 790, 430);
  } else {
    ExerciseNumber+=1;
    CheckingNumber = 0;
  }

  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}


void Squat() {
  counter();
  if (MotionNumber<30) {
    if ((FirstKnee>-70&&FirstKnee<-30)&&(SecondKnee>-150&&SecondKnee<-90)&&(FirstKneeL>-150&FirstKneeL<-100)&&(SecondKneeL>-105&&SecondKneeL<-45)) {
      println("Squat!");
      image(Squat, 0, 0, width, height);
      MotionNumber += 1;
      oldcounter = counter;
      CheckingNumber = 0;
    } else {
      println("Squat 탐색중....("+MotionNumber+"/30)");
      image(Squat, 0, 0, width, height);
      text(MotionNumber, motionx, motiony);
      text("/30", 730, 420);
      if ((CheckingNumber>=10&&MotionNumber==0)||(CheckingNumber>=5&&MotionNumber>0)) {
        println("자세 교정이 필요합니다!!!");
        image(Squat_Warning, 0, 0, width, height);
      }
    }
  } else {
    image(Squat_Complete, 0, 0, width, height);
    if (counter - oldcounter == 5) {
      println("완료");
      MotionNumber = 0;
      ExerciseNumber +=1;
    } else {
      s = counter - oldcounter;
      println("5초간 동작을 유지해주세요 "+ s + "초.....");
      text(s, secondx, secondy);   
      text("초", chox, secondy);
      CheckingNumber= 0;
    }
  }
  text(MotionNumber, motionx, motiony);
  text("/30", totalx, motiony);
  SetScale(2); 
  image(kinect.userImage(), Sx, Sy, Width, Height);
}

void Waiting() {
  if (Kind == 1) {
    if (WaitingNumber == 1) {
      image(Shoulder1_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    } else if (WaitingNumber == 2) {
      image(Shoulder2_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    } else {
      image(Shoulder3_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    }
  } else if (Kind ==2) {
    if (WaitingNumber == 1) {
      image(Waist1_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    } else if (WaitingNumber == 2) {
      image(Waist2_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    } else {
      image(Waist3_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    }
  } else {
    if (WaitingNumber == 1) {
      image(Leg1_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    } else if (WaitingNumber == 2) {
      image(Leg2_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    } else {
      image(Leg3_Waiting, 0, 0, width, height);
        image(kinect.userImage(), Sx, Sy, Width, Height);
    }
  }
}

void Ending(){
  if(Kind == 1) {
    image(Shoulder_END, 0, 0, width, height);
  } else if(Kind == 2){
     image(Waist_END, 0, 0, width, height);
  } else {
    image(Leg_END, 0, 0, width,height);
  }
}

// 다리운동 프로세싱 테스트용
void LegExercise() {
  if (ExerciseNumber == 0) {

    Standard();
  } else if (ExerciseNumber == 1) {
    LegextentionL();
  } else if (ExerciseNumber == 2) { 
    LegextentionL2();
  } else if (ExerciseNumber == 3) {
    LegextentionR();
  } else if (ExerciseNumber == 4) {
    LegextentionR2();
  } else if (ExerciseNumber == 5) {
    LungeLReady();
  } else if (ExerciseNumber == 6) {
    LungeL();
  } else if (ExerciseNumber == 7) {
    LungeRReady();
  } else if (ExerciseNumber == 8) {
    LungeR();
  } else if (ExerciseNumber == 9) {
    SquatReady();
  } else if (ExerciseNumber == 10) {
    Squat();
  } else {
    ExerciseNumber = 0;
  }
}
//어깨운동 프로세싱 테스트용
void ShoulderExercise() {
  if (ExerciseNumber == 0) {
    Standard();
  } else if (ExerciseNumber == 1) {
    HandsUp();
  } else if (ExerciseNumber == 2) {
    InfraspinatusR();
  } else if (ExerciseNumber == 3) {
    InfraspinatusR2();
  } else if (ExerciseNumber == 4) {
    InfraspinatusL();
  } else if (ExerciseNumber == 5) {
    InfraspinatusL2();
  } else if (ExerciseNumber == 6) {
    ShoulderStretching();
  } else if (ExerciseNumber == 7) {
    ShoulderStretching2();
  } else {
    ExerciseNumber = 0;
  }
}




//허리운동 프로세싱 테스트용
void WaistExercise() {
  if (ExerciseNumber ==0 ) {
    Standard();
  } else if (ExerciseNumber == 1) {
    InfraspinatusR();
  } else if (ExerciseNumber == 2) {
    QuadrateStretchingR();
  } else if (ExerciseNumber == 3) {
    InfraspinatusL();
  } else if (ExerciseNumber == 4) {
    QuadrateStretchingL();
  } else if (ExerciseNumber == 5) {
    BackDumbingReady();
  } else if (ExerciseNumber == 6) {
    BackDumbing();
  } else if (ExerciseNumber == 7) {
    BackDumbing2();
  } else if (ExerciseNumber ==8) {
    SpinaeStretchingReady();
  } else if (ExerciseNumber ==9) { 
    SpinaeStretching();
  } else {
    ExerciseNumber = 0;
  }
}

//동작 : 어깨1
void shoulder1() {
  if (ExerciseNumber == 0) {
    Kind = 0;
    Standard();
  } else if (ExerciseNumber == 1) {
    HandsUp();
  } else {
    ExerciseNumber = 0;
    status = "";
  }
}
//동작 : 어깨2
void shoulder2() {
  if (ExerciseNumber == 0) {
    Kind2=0;
    InfraspinatusR();
  } else if (ExerciseNumber == 1) {
    InfraspinatusR2();
  } else if (ExerciseNumber == 2) {
    Kind2=0;
    InfraspinatusL();
  } else if (ExerciseNumber == 3) {
    InfraspinatusL2();
  } else {
    ExerciseNumber = 0;
    status = "";
  }
}

// 동작 : 어깨3
void shoulder3() {
  if (ExerciseNumber == 0) {
    ShoulderStretching();
  } else if (ExerciseNumber == 1) {
    ShoulderStretching2();
  } else {
    Waiting();
    status = "";
  }
}

// 동작 : 허리1
void waist1() {
  if (ExerciseNumber ==0 ) {
    Kind = 1;
    Standard();
  } else if (ExerciseNumber == 1) {
    Kind2 = 1;
    InfraspinatusR();
  } else if (ExerciseNumber == 2) {
    QuadrateStretchingR();
  } else if (ExerciseNumber == 3) {
    Kind2 = 1;
    InfraspinatusL();
  } else if (ExerciseNumber == 4) {
    QuadrateStretchingL();
  } else {
        Waiting();
    status = "";
  }
}
// 동작 : 허리2
void waist2() {
  if (ExerciseNumber == 0) {
    BackDumbingReady();
  } else if (ExerciseNumber == 1) {
    BackDumbing();
  } else if (ExerciseNumber == 2) {
    BackDumbing2();
  } else {
        Waiting();
    status = "";
  }
}

// 동작 : 허리3
void waist3() {
  if (ExerciseNumber == 0 ) {
    SpinaeStretchingReady();
  } else if (ExerciseNumber == 1 ) {
    SpinaeStretching();
  } else {
        Waiting();
    status = "";
  }
}
// 동작 : 다리1
void leg1() {
  if (ExerciseNumber == 0) {
    Kind = 2;
    Standard();
  } else if (ExerciseNumber == 1) {
    LegextentionL();
  } else if (ExerciseNumber == 2) { 
    LegextentionL2();
  } else if (ExerciseNumber == 3) {
    LegextentionR();
  } else if (ExerciseNumber == 4) {
    LegextentionR2();
  } else {
        Waiting();
    status = "";
  }
}
// 동작 : 다리2
void leg2() {
  if (ExerciseNumber == 0) {
    LungeLReady();
  } else if (ExerciseNumber == 1) {
    LungeL();
  } else if (ExerciseNumber == 2) {
    LungeRReady();
  } else if (ExerciseNumber == 3) {
    LungeR();
  } else {
        Waiting();
    status = "";
  }
}
// 동작 : 다리3
void leg3() {
  if (ExerciseNumber == 0) {
    SquatReady();
  } else if (ExerciseNumber == 1) {
    Squat();
  } else {
        Waiting();
    status = "";
  }
}
//결과화면 : 어깨
void shoulderResult() {
}
//결과화면 : 허리
void waistResult() {
}
//결과화면 : 다리
void legResult() {
}
