#!/bin/bash

systemctl start ssh

Xvfb :0 -screen 0 1920x1080x24 &
export DISPLAY=:0

dbus-run-session -- startxfce4 &
x11vnc -passwd test -display :0 -forever -shared