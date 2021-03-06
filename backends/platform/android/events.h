/* ResidualVM - A 3D game interpreter
 *
 * ResidualVM is the legal property of its developers, whose names
 * are too numerous to list here. Please refer to the COPYRIGHT
 * file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 */

#ifndef ANDROID_EVENTS_H
#define ANDROID_EVENTS_H

#include "common/events.h"

class KeyReceiver {
public:
	enum KeyPressType { DOWN, UP, PRESS };
	virtual void keyPress(const Common::KeyCode code, const KeyPressType type = PRESS) = 0;
	virtual ~KeyReceiver() {};
};

// $ANDROID_NDK/platforms/android-9/arch-arm/usr/include/android/keycodes.h
// http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob;f=libs/ui/Input.cpp
// http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob;f=core/java/android/view/KeyEvent.java

// event type
enum {
	JE_SYS_KEY = 0,
	JE_KEY = 1,
	JE_DPAD = 2,
	JE_DOWN = 3,
	JE_SCROLL = 4,
	JE_TAP = 5,
	JE_DOUBLE_TAP = 6,
	JE_MULTI = 7,
	JE_BALL = 8,
	JE_TOUCH = 9,
	JE_LONG = 10,
	JE_FLING = 11,
	JE_QUIT = 0x1000
};

// action type
enum {
	JACTION_DOWN = 0,
	JACTION_UP = 1,
	JACTION_MOVE = 2,
	JACTION_POINTER_DOWN = 5,
	JACTION_POINTER_UP = 6
};

// system keys
enum {
	JKEYCODE_SOFT_RIGHT = 2,
	JKEYCODE_HOME = 3,
	JKEYCODE_BACK = 4,
	JKEYCODE_CALL = 5,
	JKEYCODE_ENDCALL = 6,
	JKEYCODE_VOLUME_UP = 24,
	JKEYCODE_VOLUME_DOWN = 25,
	JKEYCODE_POWER = 26,
	JKEYCODE_CAMERA = 27,
	JKEYCODE_HEADSETHOOK = 79,
	JKEYCODE_FOCUS = 80,
	JKEYCODE_MENU = 82,
	JKEYCODE_SEARCH = 84,
	JKEYCODE_MUTE = 91,
	JKEYCODE_MEDIA_PLAY_PAUSE = 85,
	JKEYCODE_MEDIA_STOP = 86,
	JKEYCODE_MEDIA_NEXT = 87,
	JKEYCODE_MEDIA_PREVIOUS = 88,
	JKEYCODE_MEDIA_REWIND = 89,
	JKEYCODE_MEDIA_FAST_FORWARD = 90
};

// five-way navigation control
enum {
	JKEYCODE_DPAD_UP = 19,
	JKEYCODE_DPAD_DOWN = 20,
	JKEYCODE_DPAD_LEFT = 21,
	JKEYCODE_DPAD_RIGHT = 22,
	JKEYCODE_DPAD_CENTER = 23
};

// meta modifier
enum {
	JMETA_SHIFT = 0x01,
	JMETA_ALT = 0x02,
	JMETA_SYM = 0x04,
	JMETA_CTRL = 0x1000
};

// map android key codes to our kbd codes
static const Common::KeyCode jkeymap[] = {
	Common::KEYCODE_INVALID, // KEYCODE_UNKNOWN
	Common::KEYCODE_INVALID, // KEYCODE_SOFT_LEFT
	Common::KEYCODE_INVALID, // KEYCODE_SOFT_RIGHT
	Common::KEYCODE_INVALID, // KEYCODE_HOME
	Common::KEYCODE_INVALID, // KEYCODE_BACK
	Common::KEYCODE_INVALID, // KEYCODE_CALL
	Common::KEYCODE_INVALID, // KEYCODE_ENDCALL
	Common::KEYCODE_0, // KEYCODE_0
	Common::KEYCODE_1, // KEYCODE_1
	Common::KEYCODE_2, // KEYCODE_2
	Common::KEYCODE_3, // KEYCODE_3
	Common::KEYCODE_4, // KEYCODE_4
	Common::KEYCODE_5, // KEYCODE_5
	Common::KEYCODE_6, // KEYCODE_6
	Common::KEYCODE_7, // KEYCODE_7
	Common::KEYCODE_8, // KEYCODE_8
	Common::KEYCODE_9, // KEYCODE_9
	Common::KEYCODE_ASTERISK, // KEYCODE_STAR
	Common::KEYCODE_HASH, // KEYCODE_POUND
	Common::KEYCODE_INVALID, // KEYCODE_DPAD_UP
	Common::KEYCODE_INVALID, // KEYCODE_DPAD_DOWN
	Common::KEYCODE_INVALID, // KEYCODE_DPAD_LEFT
	Common::KEYCODE_INVALID, // KEYCODE_DPAD_RIGHT
	Common::KEYCODE_INVALID, // KEYCODE_DPAD_CENTER
	Common::KEYCODE_INVALID, // KEYCODE_VOLUME_UP
	Common::KEYCODE_INVALID, // KEYCODE_VOLUME_DOWN
	Common::KEYCODE_INVALID, // KEYCODE_POWER
	Common::KEYCODE_INVALID, // KEYCODE_CAMERA
	Common::KEYCODE_INVALID, // KEYCODE_CLEAR
	Common::KEYCODE_a, // KEYCODE_A
	Common::KEYCODE_b, // KEYCODE_B
	Common::KEYCODE_c, // KEYCODE_C
	Common::KEYCODE_d, // KEYCODE_D
	Common::KEYCODE_e, // KEYCODE_E
	Common::KEYCODE_f, // KEYCODE_F
	Common::KEYCODE_g, // KEYCODE_G
	Common::KEYCODE_h, // KEYCODE_H
	Common::KEYCODE_i, // KEYCODE_I
	Common::KEYCODE_j, // KEYCODE_J
	Common::KEYCODE_k, // KEYCODE_K
	Common::KEYCODE_l, // KEYCODE_L
	Common::KEYCODE_m, // KEYCODE_M
	Common::KEYCODE_n, // KEYCODE_N
	Common::KEYCODE_o, // KEYCODE_O
	Common::KEYCODE_p, // KEYCODE_P
	Common::KEYCODE_q, // KEYCODE_Q
	Common::KEYCODE_r, // KEYCODE_R
	Common::KEYCODE_s, // KEYCODE_S
	Common::KEYCODE_t, // KEYCODE_T
	Common::KEYCODE_u, // KEYCODE_U
	Common::KEYCODE_v, // KEYCODE_V
	Common::KEYCODE_w, // KEYCODE_W
	Common::KEYCODE_x, // KEYCODE_X
	Common::KEYCODE_y, // KEYCODE_Y
	Common::KEYCODE_z, // KEYCODE_Z
	Common::KEYCODE_COMMA, // KEYCODE_COMMA
	Common::KEYCODE_PERIOD, // KEYCODE_PERIOD
	Common::KEYCODE_LALT, // KEYCODE_ALT_LEFT
	Common::KEYCODE_RALT, // KEYCODE_ALT_RIGHT
	Common::KEYCODE_LSHIFT, // KEYCODE_SHIFT_LEFT
	Common::KEYCODE_RSHIFT, // KEYCODE_SHIFT_RIGHT
	Common::KEYCODE_TAB, // KEYCODE_TAB
	Common::KEYCODE_SPACE, // KEYCODE_SPACE
	Common::KEYCODE_LCTRL, // KEYCODE_SYM
	Common::KEYCODE_INVALID, // KEYCODE_EXPLORER
	Common::KEYCODE_INVALID, // KEYCODE_ENVELOPE
	Common::KEYCODE_RETURN, // KEYCODE_ENTER
	Common::KEYCODE_BACKSPACE, // KEYCODE_DEL
	Common::KEYCODE_BACKQUOTE, // KEYCODE_GRAVE
	Common::KEYCODE_MINUS, // KEYCODE_MINUS
	Common::KEYCODE_EQUALS, // KEYCODE_EQUALS
	Common::KEYCODE_LEFTPAREN, // KEYCODE_LEFT_BRACKET
	Common::KEYCODE_RIGHTPAREN, // KEYCODE_RIGHT_BRACKET
	Common::KEYCODE_BACKSLASH, // KEYCODE_BACKSLASH
	Common::KEYCODE_SEMICOLON, // KEYCODE_SEMICOLON
	Common::KEYCODE_QUOTE, // KEYCODE_APOSTROPHE
	Common::KEYCODE_SLASH, // KEYCODE_SLASH
	Common::KEYCODE_AT, // KEYCODE_AT
	Common::KEYCODE_INVALID, // KEYCODE_NUM
	Common::KEYCODE_INVALID, // KEYCODE_HEADSETHOOK
	Common::KEYCODE_INVALID, // KEYCODE_FOCUS
	Common::KEYCODE_PLUS, // KEYCODE_PLUS
	Common::KEYCODE_INVALID, // KEYCODE_MENU
	Common::KEYCODE_INVALID, // KEYCODE_NOTIFICATION
	Common::KEYCODE_INVALID, // KEYCODE_SEARCH
	Common::KEYCODE_INVALID, // KEYCODE_MEDIA_PLAY_PAUSE
	Common::KEYCODE_INVALID, // KEYCODE_MEDIA_STOP
	Common::KEYCODE_INVALID, // KEYCODE_MEDIA_NEXT
	Common::KEYCODE_INVALID, // KEYCODE_MEDIA_PREVIOUS
	Common::KEYCODE_INVALID, // KEYCODE_MEDIA_REWIND
	Common::KEYCODE_INVALID, // KEYCODE_MEDIA_FAST_FORWARD
	Common::KEYCODE_INVALID, // KEYCODE_MUTE
	Common::KEYCODE_PAGEUP, // KEYCODE_PAGE_UP
	Common::KEYCODE_PAGEDOWN // KEYCODE_PAGE_DOWN
};

#endif
