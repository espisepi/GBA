; Game Boy Advance 'Bare Metal' 3D Engine Demo by krom (Peter Lemon):
; God Camera Controls:
; Direction Pad Moves Forward/Backward & Strafes Left/Right
; A/B Buttons Move Camera Up/Down
; L/R Buttons Yaw Camera
; Start/Select Buttons Pitch Camera

format binary as 'gba'
org $8000000
include 'LIB\FASMARM.INC' ; Include FASMARM Macros
include 'LIB\GBA.INC' ; Include GBA Definitions
include 'LIB\GBA_DMA.INC' ; Include GBA DMA Macros
include 'LIB\GBA_KEYPAD.INC' ; Include GBA Keypad Macros
include 'LIB\GBA_LCD.INC' ; Include GBA LCD Macros
include 'LIB\GBA_HEADER.ASM' ; Include GBA Header & ROM Entry Point

include 'LIB\2D.INC'
include 'LIB\3D.INC'

; Setup Frame Buffer
SCREEN_X       = 240
SCREEN_Y       = 160
BITS_PER_PIXEL = 16

; Setup 3D
HALF_SCREEN_X = (SCREEN_X / 2)
HALF_SCREEN_Y = (SCREEN_Y / 2)
CAMERA_MOVE_SPEED = 256 ; 1.0 World Unit Per Frame
CAMERA_TURN_SPEED = 1

macro Control {
  IsKeyDown KEY_SELECT
  imm32eq r0,XRot ; Load X Rotate Address To R0
  ldreq r1,[r0] ; Load X Rotate Word To R1
  subeq r1,CAMERA_TURN_SPEED
  andeq r1,255
  streq r1,[r0] ; Store Word To X Rotate

  IsKeyDown KEY_START
  imm32eq r0,XRot ; Load X Rotate Address To R0
  ldreq r1,[r0] ; Load X Rotate Word To R1
  addeq r1,CAMERA_TURN_SPEED
  andeq r1,255
  streq r1,[r0] ; Store Word To X Rotate

  IsKeyDown KEY_L
  imm32eq r0,YRot ; Load Y Rotate Address To R0
  ldreq r1,[r0] ; Load Y Rotate Word To R1
  subeq r1,CAMERA_TURN_SPEED
  andeq r1,255
  streq r1,[r0] ; Store Word To Y Rotate

  IsKeyDown KEY_R
  imm32eq r0,YRot ; Load Y Rotate Address To R0
  ldreq r1,[r0] ; Load Y Rotate Word To R1
  addeq r1,CAMERA_TURN_SPEED
  andeq r1,255
  streq r1,[r0] ; Store Word To Y Rotate
}

macro GodCameraMove {
  mov r4,0 ; Local Camera X Movement
  mov r5,0 ; Local Camera Y Movement
  mov r6,0 ; Local Camera Z Movement

  IsKeyDown KEY_LEFT
  subeq r4,CAMERA_MOVE_SPEED ; Strafe Left
  IsKeyDown KEY_RIGHT
  addeq r4,CAMERA_MOVE_SPEED ; Strafe Right
  IsKeyDown KEY_A
  subeq r5,CAMERA_MOVE_SPEED ; Fly Up
  IsKeyDown KEY_B
  addeq r5,CAMERA_MOVE_SPEED ; Fly Down
  IsKeyDown KEY_UP
  addeq r6,CAMERA_MOVE_SPEED ; Move Forward
  IsKeyDown KEY_DOWN
  subeq r6,CAMERA_MOVE_SPEED ; Move Backward

  imm32 r12,Matrix3D ; Load Rotation Matrix Address
  ldr r0,[r12] ; Matrix3D[0]
  mul r7,r0,r4
  ldr r0,[r12,16] ; Matrix3D[4]
  mla r7,r0,r5,r7
  ldr r0,[r12,32] ; Matrix3D[8]
  mla r7,r0,r6,r7
  asr r7,8 ; World Camera X Movement

  ldr r0,[r12,4] ; Matrix3D[1]
  mul r8,r0,r4
  ldr r0,[r12,20] ; Matrix3D[5]
  mla r8,r0,r5,r8
  ldr r0,[r12,36] ; Matrix3D[9]
  mla r8,r0,r6,r8
  asr r8,8 ; World Camera Y Movement

  ldr r0,[r12,8] ; Matrix3D[2]
  mul r9,r0,r4
  ldr r0,[r12,24] ; Matrix3D[6]
  mla r9,r0,r5,r9
  ldr r0,[r12,40] ; Matrix3D[10]
  mla r9,r0,r6,r9
  asr r9,8 ; World Camera Z Movement

  imm32 r12,CameraX ; Load Camera Position Address
  ldmia r12,{r0-r2\}
  add r0,r7
  add r1,r8
  add r2,r9
  stmia r12,{r0-r2\}
}

macro BuildCameraView {
  imm32 r11,CameraX ; Load Camera Position Address
  ldmia r11,{r4-r6\} ; R4 = Camera X, R5 = Camera Y, R6 = Camera Z
  imm32 r12,Matrix3D ; Load Matrix Address

  ldr r0,[r12] ; Matrix3D[0]
  mul r7,r0,r4
  ldr r0,[r12,4] ; Matrix3D[1]
  mla r7,r0,r5,r7
  ldr r0,[r12,8] ; Matrix3D[2]
  mla r7,r0,r6,r7
  rsb r7,r7,0
  asr r7,8
  str r7,[r12,12] ; Matrix3D[3] = View X Translation

  ldr r0,[r12,16] ; Matrix3D[4]
  mul r7,r0,r4
  ldr r0,[r12,20] ; Matrix3D[5]
  mla r7,r0,r5,r7
  ldr r0,[r12,24] ; Matrix3D[6]
  mla r7,r0,r6,r7
  rsb r7,r7,0
  asr r7,8
  str r7,[r12,28] ; Matrix3D[7] = View Y Translation

  ldr r0,[r12,32] ; Matrix3D[8]
  mul r7,r0,r4
  ldr r0,[r12,36] ; Matrix3D[9]
  mla r7,r0,r5,r7
  ldr r0,[r12,40] ; Matrix3D[10]
  mla r7,r0,r6,r7
  rsb r7,r7,0
  asr r7,8
  str r7,[r12,44] ; Matrix3D[11] = View Z Translation
}

copycode:
  adr r0,startcode
  mov r1,IWRAM
  imm32 r2,endcopy
  clp:
    ldr r3,[r0],4
    str r3,[r1],4
    cmp r1,r2
    bmi clp
  imm32 r0,start
  bx r0
startcode:
  org IWRAM

; Variable Data (IWRAM)
XRot: dw 0 ; X Rotate Word (0..255) (Jump To Correct X Rotation Pre Calculated Table Memory)
YRot: dw 0 ; Y Rotate Word (0..255) (Jump To Correct X Rotation Pre Calculated Table Memory)
ZRot: dw 0 ; Z Rotate Word (0..255) (Jump To Correct X Rotation Pre Calculated Table Memory)

CameraX: dw 0 ; Camera X Position
CameraY: dw 0 ; Camera Y Position
CameraZ: dw -25600 ; Camera Z Position (-100.0 Keeps The Scene In Front Of The Camera)

Matrix3D: ; 3D Matrix: Set To Default Identity Matrix (All Numbers Multiplied By 256 For 24.8 Fixed Point Format)
  dw 256, 0, 0, 0 ; X = 1.0, 0.0, 0.0, X Translation = 0.0
  dw 0, 256, 0, 0 ; 0.0, Y = 1.0, 0.0, Y Translation = 0.0
  dw 0, 0, 256, 25600 ; 0.0, 0.0, Z = 1.0, Z Translation = 100.0

LineCache:
  dw 0, 0, 0 ; Cache 1st X, Y, Z Point In Line
  dw 0, 0, 0 ; Cache 2nd X, Y, Z Point In Line
  dw 0, 0, 0 ; Cache 3rd X, Y, Z Point In Line
  dw 0, 0, 0 ; Cache 4th X, Y, Z Point In Line

ScanLeft:  dh SCREEN_Y dup 0 ; Left  Hand Scanline X Buffer (Size Of Screen Y)
ScanRight: dh SCREEN_Y dup 0 ; Right Hand Scanline X Buffer (Size Of Screen Y)

include 'sincos256.asm' ; Matrix Sin & Cos Pre-Calculated Table (256 Rotations)

start:
  mov r0,IO
  mov r1,MODE_3
  orr r1,BG2_ENABLE
  str r1,[r0]

Refresh:
  Control
  XYZRotCalc XRot, YRot, ZRot, SinCos256 ; Combine X,Y,Z Rotation Matrix
  GodCameraMove
  BuildCameraView

  ClearCol $FFFFFFFF, WRAM, 76800 ; Clear Color (32 Bits For CPU Fixed Copy)
  ClearZBuf ; Clear Z-Buffer (Only Required When Using Z-buffer)

  FillQuadCullBack CubeQuad, CubeQuadEnd
  FillTriCullBack PyramidTri, PyramidTriEnd
  LineZBuf GrassLine, GrassLineEnd
  PointZBuf StarPoint, StarPointEnd

  SwapBuffers WRAM, VRAM, 76800 ; Swap Buffers

  b Refresh

endcopy: ; End Of Program Copy Code

; Static Data (ROM)
org startcode + (endcopy - IWRAM)
include 'ReciprocalLUT.asm' ; Reciprocal LUT
include 'objects.asm' ; Objects Data
