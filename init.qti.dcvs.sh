#! /vendor/bin/sh
#
# Copyright (c) 2020, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of The Linux Foundation nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
    for device in /sys/devices/platform/soc
    do
        #Enable mem_latency governor for L3, LLCC, and DDR scaling
        for memlat in $device/*cpu*-lat/devfreq/*cpu*-lat
        do
            cat $memlat/available_frequencies | cut -d " " -f 1 > $memlat/min_freq
            echo "mem_latency" > $memlat/governor
            echo 10 > $memlat/polling_interval
            echo 400 > $memlat/mem_latency/ratio_ceil
         done

         #Gold L3 ratio ceil
        for l3gold in $device/*cpu6-cpu-l3-lat/devfreq/*cpu6-cpu-l3-lat
        do
            echo 4000 > $l3gold/mem_latency/ratio_ceil
        done

        #Enable compute governor for gold latfloor
        for latfloor in $device/*cpu*-ddr-latfloor*/devfreq/*cpu-ddr-latfloor*
        do
            cat $latfloor/available_frequencies | cut -d " " -f 1 > $latfloor/min_freq
            echo "compute" > $latfloor/governor
            echo 10 > $latfloor/polling_interval
        done
    done;
