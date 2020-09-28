#!/bin/bash
#
#
#############################################################################################################################################################
#
#
# This exec will run all the time and wake up every 1 min to update any zVM RACF changes between all zVM systems.
#
# To stop this exec from doing the updates:  echo N > /opt/IBM/TDI/logs/run_sync_flag
# To sart this exec for doing updates again: echo Y > /opt/IBM/TDI/logs/run_sync_flag
#
# If the process notes that the last update did not work it will send a alert message to the syslog and then	
# slow down from every 1 minute sync to 30 minutes sync.
#
# when the issue is resolved it will speed back up again to every 1 minute sync.
#
# 12MAR15 v536827 (paul) commented out the alert as since zVM VMLX1 has been upgraded REVOKEs from that system are bredking the flow
#                        every day 5 or more times. zVM team has been told but not yet fixed or said its them.
#                        I asked if they did add all the PTFs we had IBM make for RACF and LDAP for zVM 6.1 to the zVM 6.3 system. not responeded yet.
#                        Since I will be away next week. The alerts have to stop. I did show Jim and Danny how to try to fix the flow before
#                        but its is not easy.
# 23JAN13 v536827 (paul) added echo N > run_sync_flag to the error step that sends the aborting alert to auto stop.
#
#############################################################################################################################################################
#  base start up                                                                                                                                           # 
############################################################################################################################################################# 
#
#
#
GO=Y
name=$(uname -n)
D=$(date +%F)
T=$(date +%T)
echo "  ***********************************************************************************" >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo "  ***** RACF Sync Process starting now on " $name"      "$D"   "$T"                  " >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo "  ***********************************************************************************" >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 1  is vmlx1'  >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 2  is vmlxw5 ** shutdown on 3-20-2012' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 3  is vmlxg3' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 4  is vmlxg2' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 5  is vmlxw2' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 6  is vmlxw3 ** shutdown on 3-21-2012' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 7  is vmlxw4 ** shutdown on 3-20-2012' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 8  is vmlxg1' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 9  is vmlxg4' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
echo 'TDI-info system 10 is vmlxg5' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log

/opt/IBM/TDI/V6.1.1/ibmdisrv -c /opt/IBM/TDI/ssc_config/03_23_12.xml -r syncChanges

#
#
#
#
#############################################################################################################################################################
while [ $GO = Y ]; do
      D=$(date +%F)
      T=$(date +%T)
      RUN=$(cat /opt/IBM/TDI/Solutions/logs/run_sync_flag)
      if [[ "$RUN" = "N" ]]
        then
         echo $D' '$T' ** /opt/IBM/TDI/Solutions/logs/run_sync_flag is set to '$RUN >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
         sleep 60
      fi

#
#
#
         while [ $RUN = Y ]; do
               RUN=$(cat /opt/IBM/TDI/Solutions/logs/run_sync_flag)
               x=$(tail -1 /opt/IBM/TDI/Solutions/logs/syncChanges.log)
               y=$(tail -2 /opt/IBM/TDI/Solutions/logs/syncChanges.log)
               TM=$(date +%H%M)
               echo $TM' Time 1' >> /opt/IBM/TDI/Solutions/logs/TM.log
#
#
#
               TM=$(date +%H%M)
               if [[ "$TM" > "2355" ]]
               then
                   echo "**** The time is now greater than 23:55 so a log swap will now be done ***" >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   mv /opt/IBM/TDI/Solutions/logs/syncChanges.log /opt/IBM/TDI/Solutions/logs/logs_history/$(date +'%m-%d-%y')
                   touch /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   chown root:esg /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   chown root:esg /opt/IBM/TDI/Solutions/logs/run_sync_flag
                   chmod 664 /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo '* Free memory before clean up' > /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   free -m >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   sync;echo 3 > /proc/sys/vm/drop_caches
                   echo ' ' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo '* Free memory after clean up' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   free -m >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo ' ' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 1  is vmlx1'  >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 2  is vmlxw5' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 3  is vmlxg3' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 4  is vmlxg2' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 5  is vmlxw2' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 6  is vmlxw3' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 7  is vmlxw4' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 8  is vmlxg1' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 9  is vmlxg4' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   echo 'TDI-info system 10 is vmlxg5' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                   /opt/IBM/TDI/V6.1.1/ibmdisrv -c /opt/IBM/TDI/ssc_config/03_23_12.xml -r syncChanges
                   sleep 600
                   TM=$(date +%H%M)
                   echo $TM' Time 2' >> /opt/IBM/TDI/Solutions/logs/TM.log
                fi
#
#
#
               if [[ "$y" =~ "Sync system aborting" ]]
               then
                     k0='|00|';v0=SSCLOG20
                     k1='|1A|';v1=-5
                     k2='|2A|';v2=A
                     k3='|2B|';v3=PRD
                     k4='|3A|';v4=ZVM
                     k5='|3B|';v5=
                     k6='|4A|';v6="zVM RACF Sync Aborting"
                     k7='|4B|';v7=
                     k8='|4C|';v8="zVM RACF password sync has stopped"
                     k9='|4D|';v9=
                     ka='|5A|';va=$(uname -n)
                     kb='|5B|';vb=
                     kc='|6A|';vc=UXZLX001
                     kd='|7A|';vd=SyncChanges.sh
                     ke='|7B|';ve=
                     kf='|8A|';vf=
                     kg='|8B|';vg=
                     kh='|FF|';vh='SSC|'
                     ERRMSG=$k0$v0$k1$v1$k2$v2$k3$v3$k4$v4$k5$v5$k6$v6$k7$v7$k8$v8$k9$v9$ka$va$kb$vb$kc$vc$kd$vd$ke$ve$kf$vf$kg$vg$kh$vh
#
#                    12MAR15 - Alert that causes ISM ticket is shut off until zVM team can fix zVM 6.3                    
#                    04MAY16 - Turned Alert back on again
#
                     logger -p local0.err $ERRMSG
#
#
                     echo '' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                     echo '*** NetCool Alert sent ' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                     echo '*** '$ERRMSG  >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                     echo '*** One sync will run now then the system will slow down to every 5 minutes till fixed'  >> /opt/IBM/TDI/Solutions/logs/syncChanges.log 
                     echo '' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log 
#
                     echo N > /opt/IBM/TDI/Solutions/logs/run_sync_flag
#
                     /opt/IBM/TDI/V6.1.1/ibmdisrv -c /opt/IBM/TDI/ssc_config/03_23_12.xml -r syncChanges
                     sleep 300
               fi
#
#
#
               if [[ "$x" =~ "CTGDIS077I Failed with error:" ]]
               then
                     echo '***************************************************************************************' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                     echo '  One of the VM systems can not be reached .....  will now wait 5 minutes and try again' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log
                     echo '***************************************************************************************' >> /opt/IBM/TDI/Solutions/logs/syncChanges.log  
                     sleep 240
                     /opt/IBM/TDI/V6.1.1/ibmdisrv -c /opt/IBM/TDI/ssc_config/03_23_12.xml -r syncChanges
               fi
#
#
#
               if [[ "$x" =~ "sync process completed" ]]
               then
                       TM=$(date +%H%M)
                       echo $TM' Time 3' >> /opt/IBM/TDI/Solutions/logs/TM.log
                       /opt/IBM/TDI/V6.1.1/ibmdisrv -c /opt/IBM/TDI/ssc_config/03_23_12.xml -r syncChanges
                       TM=$(date +%H%M)
                       echo $TM' Time 4' >> /opt/IBM/TDI/Solutions/logs/TM.log
                       sleep=60
                       TM=$(date +%H%M)
                       echo $TM' Time 5' >> /opt/IBM/TDI/Solutions/logs/TM.log
               fi
#
#
               if [[ "$x" =~ "is set to N" ]]
               then
                     echo $D' '$T' ** /opt/IBM/TDI/Solutions/logs/run_sync_flag is set to '$RUN >> /opt/IBM/TDI/Solutions/logs/syncChanges.log 
                     /opt/IBM/TDI/V6.1.1/ibmdisrv -c /opt/IBM/TDI/ssc_config/03_23_12.xml -r syncChanges
                     sleep=60
               fi
#
     sleep 60
#
#
     done
#
#
#
done
