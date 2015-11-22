#!/bin/bash
pidfile="qemu.pid"
kill $(cat $pidfile) && rm $pidfile
