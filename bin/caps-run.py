#!/usr/bin/env python3
import ctypes
import subprocess


def toggle_caps_lock(enable):
    XkbUseCoreKbd = ctypes.c_uint(0x0100)
    keys = ctypes.c_uint(2)
    state = keys if enable else ctypes.c_uint(0)

    X11 = ctypes.cdll.LoadLibrary("libX11.so.6")
    display = X11.XOpenDisplay(None)

    X11.XkbLockModifiers(display, XkbUseCoreKbd, keys, state)

    X11.XCloseDisplay(display)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.description = 'Turns off Caps Lock and run a command'
    parser.add_argument('command')
    parser.add_argument('args', nargs=argparse.REMAINDER)
    args = parser.parse_args()

    toggle_caps_lock(False)
    subprocess.run([args.command] + args.args)
