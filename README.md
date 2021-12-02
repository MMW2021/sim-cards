# Sim card install script

This script installs the configuration files needed to connect to the internet with the sim7000emodem connected over usb
it also installs a system servicefhich can be enabled once the connection has been verified

Once the conf files are installed, run
```bash
sudo pppd call gprs
```
to test.

If theconnection was successful, a new interface will be registered by pppd
It'll look like below

![ifconfig preview](./preview.png)