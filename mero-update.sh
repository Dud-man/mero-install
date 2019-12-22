CONFIG_FILE='mero.conf'
CONFIGFOLDER='/root/.mero'
COIN_DAEMON='/usr/local/bin/merod'
COIN_CLI='/usr/local/bin/mero-cli'
COIN_REPO='https://github.com/Dud-man/mero/releases/tag/v2.0/mero-2.0.0-x86_64-linux-gnu.tar.gz'
COIN_NAME='MeroCoin'
COIN_ZIP='mero-2.0.0-x86_64-linux-gnu.tar.gz'
COIN_PORT=14550

if [ -e /usr/local/bin/mero-cli ] && [ -e /usr/local/bin/merod ]; then
	echo ""
	echo "#######################################"
	echo "#   Stopping Mero services (daemon)    #"
	echo "#######################################"
	echo ""

	wallstatus=$( mero-cli mnsync status ) || true
	if [ -z "$wallstatus" ]; then
		echo "Daemon is not running no need to stop it"
	else
		echo "Stopping the Daemon"
		systemctl stop $COIN_NAME.service
		sleep 60

		wallstatus=$( mero-cli mnsync status ) || true
		if [ -z "$wallstatus" ]; then
			echo "Daemon stopped!"
		else
			echo "Daemon was not stopped! Please kill the deamon process or run ./mero-cli stop, then run the script again"
			exit
		fi
	fi

    echo ""
	echo "###############################"
	echo "#   Removing old binaries    #"
	echo "###############################"
	echo ""

	if [ -e /usr/local/bin/mero-cli ]; then
		echo "Removing mero-cli"
		rm /usr/local/bin/mero-cli
	fi

	if [ -e /usr/local/bin/merod ]; then
		echo "Removing merod"
		rm  /usr/local/bin/merod
	fi

	if [ -e /usr/local/bin/mero-qt ]; then
		echo "Removing mero-qt"
		rm /usr/local/bin/mero-qt
	fi

    	if [ -e /usr/local/bin/mero-tx ]; then
		echo "Removing mero-tx"
		rm /usr/local/bin/mero-tx
	fi

	
else
	is_mero_running=`ps ax | grep -v grep | grep merod | wc -l`
	if [ $is_mero_running -gt 0 ]; then
		echo "Mero process is still running, it's not safe to continue with the update, exiting."
		echo "Please stop the daemon with './mero-cli stop' or kill the daeomon process, then run the script again."
		exit -1
	fi
fi

echo ""
echo "#######################################"
echo "#      Backing up the wallet.dat      #"		
echo "#######################################"
echo ""
is_mero_running=`ps ax | grep -v grep | grep merod | wc -l`
if [ $is_mero_running -gt 0 ]; then
	echo "Mero process is still running, it's not safe to continue with the update, exiting."
	echo "Please stop the daemon with './mero-cli stop' or kill the daemon process, then run the script again."
	exit -1
else
	currpath=$( pwd )
	echo "Backing up the wallet.dat"
	backupsdir="mero_wallet_backups"
	mkdir -p $backupsdir
	backupfilename=wallet.dat.$(date +%F_%T)
	cp ~/.mero/wallet.dat "$currpath/$backupsdir/$backupfilename"
	echo "wallet.dat was saved to : $currpath/$backupsdir/$backupfilename"
fi

echo ""
echo "###############################"
echo "#   Get/Setup new binaries    #"
echo "###############################"
echo ""

if test -e "$COIN_ZIP"; then
	rm -r $COIN_ZIP
fi

TMP_FOLDER=$(mktemp -d)
cd $TMP_FOLDER
wget $COIN_REPO

if test -e "$COIN_ZIP"; then
    tar xvzf $COIN_ZIP
    rm -f $COIN_ZIP >/dev/null 2>&1
    cp mero-2.0.0/bin/mero* /usr/local/bin
    cd -
    rm -rf $TMP_FOLDER >/dev/null 2>&1
    clear
else
	echo "There was a problem downloading the binaries, please try running again the script."
	exit -1
fi

echo ""
echo "###########################"
echo "#   Running the daemon    #"
echo "###########################"
echo ""

cd ~/
systemctl start $COIN_NAME.service
echo "Waiting for daemon to be up and running"
sleep 60
mero-cli getinfo
echo "MERO Updated!"
echo "Remember to go to your cold wallet and start the masternode (cold wallet must also be on the latest version)."
