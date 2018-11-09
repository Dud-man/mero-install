# MeroCoin
Shell script to install a [MeroCoin Masternode] on a Linux server running Ubuntu 14.04 or 16.04. Use it on your own risk.

***
## Installation:
```
git clone https://github.com/MeroCoin/mero-install.git
cd mero-install
bash mero-install.sh
```
***

## Desktop wallet setup

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps for Windows Wallet
1. Open the MeroCoin Coin Desktop Wallet.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **1000** **MeroCoin** to **MN1**.
4. Wait for 15 confirmations.
5. Go to **Tools -> "Debug console - Console"**
6. Type the following command: **masternode outputs**
7. Go to  ** Tools -> "Open Masternode Configuration File"
8. Add the following entry:
```
Alias Address Privkey TxHash Output_index
```
* Alias: **MN1**
* Address: **VPS_IP:PORT**
* Privkey: **Masternode Private Key**
* TxHash: **First value from Step 6**
* Output index:  **Second value from Step 6**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is unlocked.
12. Open **Debug Console** and type:
```
startmasternode "alias" "0" "MN1"
```
***

## Usage:
```
mero-cli getinfo
mero-cli mnsync status
mero-cli masternode status
```
Also, if you want to check/start/stop **MeroCoin** , run one of the following commands as **root**:

**Ubuntu 16.04**:
```
systemctl status MeroCoin #To check the service is running.
systemctl start MeroCoin #To start MeroCoin service.
systemctl stop MeroCoin #To stop MeroCoin service.
systemctl is-enabled MeroCoin #To check whetether MeroCoin service is enabled on boot or not.
```
**Ubuntu 14.04**:  
```
/etc/init.d/MeroCoin start #To start MeroCoin service
/etc/init.d/MeroCoin stop #To stop MeroCoin service
/etc/init.d/MeroCoin restart #To restart MeroCoin service
```
***
