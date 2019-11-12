
#ifndef PONG_PARAMETERS_H
#define PONG_PARAMETERS_H

#include <xil_io.h>

#include "xparameters.h"
#include "xbasic_types.h"

/** Update Interrupt */
#define UPDATE_RATE	(66) 		// We want to update the screen 50 times per second
#define INTERRUPT_RATE (1000)	// The Interrupt is generated every millisecond (by the fixed interval timer)
#define INTERRUPT_COUNT (INTERRUPT_RATE / UPDATE_RATE)

/** Button Definitions */
#define LEFT_BUTTON_MASK (0x00000008)
#define RIGHT_BUTTON_MASK (0x00000002)
#define UP_BUTTON_MASK (0x00000001)
#define DOWN_BUTTON_MASK (0x00000004)
#define RESTART_BUTTON_MASK (0x00000010)

/** Graphics Dimensions */
#define SCREEN_WIDTH ((Xuint32)640)
#define SCREEN_HEIGHT ((Xuint32)480)

#define BALL_WIDTH ((Xuint32)20)
#define BALL_HEIGHT ((Xuint32)20)
#define PLATE_WIDTH ((Xuint32)90)
#define PLATE_HEIGHT ((Xuint32)10)
#define SUBPLATE_WIDTH ((Xuint32)45)
#define SUBPLATE_HEIGHT ((Xuint32)6)

#define SIDE_SIZE ((Xuint32)25)
#define BLOCK_WIDTH ((Xuint32)150)
#define BOOST_WIDTH ((Xuint32)10)
#define SIDE_WIDTH ((Xuint32)25)

#define PLATEZONE_HEIGHT ((Xuint32)80)


//define constants
#define BALL_NUM (4)
#define BLOCK1_X (SCREEN_WIDTH/4 - BLOCK_WIDTH/2)
#define BLOCK2_X (3*SCREEN_WIDTH/4 - BLOCK_WIDTH/2)
#define BALL_Y_MAX (200)


/** Movement Speeds */
/* In Pixels per Update */
#define PLATE_SPEED (5)
#define BALLX_SPEED (3)
#define BALL_X_MAX_SPEED (6)
#define BALLY_SPEED (2)
#define BLOCKS_INV_SPEED (8)


/** Memory Definition for PongGraphics ip-core */
/* Offset needs to be specified in bytes */


#define SCORE_OFFSET (0)
#define HIGHSCORE_OFFSET (4)

#define PLATEX_OFFSET (8)
#define PLATEY_OFFSET (12)

#define SUBPLATEX_OFFSET (16)
#define SUBPLATEY_OFFSET (20)

#define BALL1X_OFFSET (24)
#define BALL1Y_OFFSET (28)

#define BALL2X_OFFSET (32)
#define BALL2Y_OFFSET (36)

#define BALL3X_OFFSET (40)
#define BALL3Y_OFFSET (44)

#define BALL4X_OFFSET (48)
#define BALL4Y_OFFSET (52)

#define BOOST1Y_OFFSET (56)
#define BOOST2Y_OFFSET (60)


#define BLOCK1Y_OFFSET (64)
#define BLOCK2Y_OFFSET (68)


#define KEY_OFFSET (0)


#define BUZZACT_OFFSET (0)

//define the sound values. sound frequencies are determined as: 10^8/(500*value)
#define BUZZSOUND1 (27)
#define BUZZSOUND2 (19)
#define BUZZSOUND3 (41)
#define BUZZSOUND4 (35)

/* We use the provided macros for memory access */
#define SET_PONG_MEMORY(OFFSET, VALUE) Xil_Out32((XPAR_BOUNCE_GRAPHICS_0_BASEADDR + OFFSET), VALUE)
#define GET_PONG_MEMORY(OFFSET) Xil_In32((XPAR_BOUNCE_GRAPHICS_0_BASEADDR + OFFSET))
#define GET_KEY_MEMORY(OFFSET) Xil_In32(XPAR_KEYBOARD_0_BASEADDR + OFFSET)
#define SET_BUZZ_MEMORY(OFFSET, VALUE) Xil_Out32((XPAR_BUZZER_0_BASEADDR + OFFSET), VALUE)

/* Set the position of the graphics on the screen */
#define setScore(VALUE) 	SET_PONG_MEMORY(SCORE_OFFSET,VALUE)
#define setHighScore(VALUE) SET_PONG_MEMORY(HIGHSCORE_OFFSET,VALUE)

#define setPlateX(XPOS) SET_PONG_MEMORY(PLATEX_OFFSET, XPOS)
#define setPlateY(YPOS) SET_PONG_MEMORY(PLATEY_OFFSET, YPOS)

#define setSubplateX(XPOS) SET_PONG_MEMORY(SUBPLATEX_OFFSET, XPOS)
#define setSubplateY(YPOS) SET_PONG_MEMORY(SUBPLATEY_OFFSET, YPOS)

#define setBall1X(XPOS) SET_PONG_MEMORY(BALL1X_OFFSET, XPOS)
#define setBall1Y(YPOS) SET_PONG_MEMORY(BALL1Y_OFFSET, YPOS)

#define setBall2X(XPOS) SET_PONG_MEMORY(BALL2X_OFFSET, XPOS)
#define setBall2Y(YPOS) SET_PONG_MEMORY(BALL2Y_OFFSET, YPOS)

#define setBall3X(XPOS) SET_PONG_MEMORY(BALL3X_OFFSET, XPOS)
#define setBall3Y(YPOS) SET_PONG_MEMORY(BALL3Y_OFFSET, YPOS)

#define setBall4X(XPOS) SET_PONG_MEMORY(BALL4X_OFFSET, XPOS)
#define setBall4Y(YPOS) SET_PONG_MEMORY(BALL4Y_OFFSET, YPOS)

#define setBoost1Y(YPOS) SET_PONG_MEMORY(BOOST1Y_OFFSET, YPOS)
#define setBoost2Y(YPOS) SET_PONG_MEMORY(BOOST2Y_OFFSET, YPOS)

#define setBlock1Y(YPOS) SET_PONG_MEMORY(BLOCK1Y_OFFSET, YPOS)
#define setBlock2Y(YPOS) SET_PONG_MEMORY(BLOCK2Y_OFFSET, YPOS)

#define getKeyvalue() GET_KEY_MEMORY(KEY_OFFSET)

#define setBuzzact(VALUE) SET_BUZZ_MEMORY(BUZZACT_OFFSET,VALUE)

#endif
