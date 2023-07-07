#!/usr/bin/env bash

# <xbar.title>Timezone</xbar.title>
# <xbar.version>v1.0.0</xbar.version>
# <xbar.author>Toni Hoffmann</xbar.author>
# <xbar.author.github>xremix</xbar.author.github>
# <xbar.desc>Show the current time of a different timezone.</xbar.desc>

#Prefix="AUT"
Time_Zone="Europe/Vienna"
#TZ=":$Time_Zone" date "+$Prefix %H:%M"
TZ=":$Time_Zone" /opt/homebrew/opt/coreutils/libexec/gnubin/date -Iminutes | sed 's#T#  #;s#+# +#'
