<<<<<<< HEAD
# Telegram MTProto Proxy (Official version fork)

[![Build Status](https://travis-ci.org/p1ratrulezzz/MTProxy-1.svg?branch=master)](https://travis-ci.org/p1ratrulezzz/MTProxy-1)

## Credits

Check the original repo https://github.com/TelegramMessenger/MTProxy and it is preferred to use it than this one as this repo won't be much maintained.
But, of course, information from this fork can be useful too.

## Disclaimer

Please, in case of any issues while build or etc, create an issue on original [repo page](https://github.com/TelegramMessenger/MTProxy)! 

## Building, installation and setting a promoted channel

## Docker

A tutorial for docker is available here https://p1ratrulezzz.me/2018/06/creating-your-own-official-mtproto-proxy-with-channel-promotion-very-easy-way.html and on the official repo https://hub.docker.com/r/telegrammessenger/proxy/


## Building and installation manually


### Installing dependencies, cloning

```bash
  apt-get install libssl-dev zlib1g-dev build-essential
  cd /opt
  git clone -b '0.0.4' https://github.com/p1ratrulezzz/MTProxy-1.git MTProxy
```

### Building

```bash
  cd /opt/MTProxy
  make
  curl -s https://core.telegram.org/getProxySecret -o proxy-secret
  curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
  ln -s /opt/MTProxy/objs/bin/mtproto-proxy /usr/bin/mtproto-proxy
  cp resources/init.d.script.sh /etc/init.d/mtproto-proxy1
  chmod +x /etc/init.d/mtproto-proxy
  cp resources/options.template.txt ./options.txt
  systemctl daemon-reload
```

### Configuration

How to generate secrets?

```bash
  head -c 16 /dev/urandom | xxd -ps
```

Edit options.txt file and set there desired values described below

```
-P <proxy tag> -- (optional) Obtain a proxy tag from telegram bot @MTProxybot if you want to attach any channel as a "Proxy sponsor channel"
-u nobody -- nobody is the user name. mtproto-proxy calls setuid() to drop privilegies
-p 8888 -- is the local port. You can use it to get statistics from mtproto. Like wget localhost:8888/stats
-H 6968 -- on which PORT to listen for connections
-S <secret> -- secret, any 32byte string (md5hash). Generate it using _head -c 16 /dev/urandom | xxd -ps_
-S <secret2> -- another secret. Optionally, you can setup several passwords (secrets) per one server,
-S <secret3> -- just pass as many -S flags as you want
-M 0 -- quantity of workers (slave processes). Zero means only one process.
--address <public_ip_here> -- set IP address got from ifconfig OR set to 0.0.0.0 which means to listen to all interfaces
--cpu-threads 2 -- threads per process. The value 2 is recommended.
--max-accept-rate 10 -- how many requests per second will be accepted. For powerful servers its possible to set 1000. For minimum users set to 10
-C 60000 -- Max connections to serve. This value was taken from docker config.
```

### Run the server for testing

```bash
  mtproto-proxy $(cat options.txt)
```

If there are no errors and Telegram client can connect, close it using Ctrl+C then run as a daemon

```bash
  service mtproto-proxy start
  service mtproto-proxy status
```

And there should be a process and Active daemon running. Check again if you can connect using Telegram client and enable the service to autorun on every reboot

```bash
  systemctl enable mtproto-proxy
```

That's it. Now you can close the SSH connection to your VPS and keep using Telegram with your new server! The statistics of usage of the server are accessible via Telegram bot @MTProxybot
### Share with friends

Generate the  link tg://proxy?server=SERVER_NAME&port=6968&secret=SECRET and https://t.me/proxy?server=SERVER_NAME&port=6968&secret=SECRET

=======
# MTProxy
Simple MT-Proto proxy

## Building
Install dependencies, you would need common set of tools for building from source, and development packages for `openssl` and `zlib`.

On Debian/Ubuntu:
```bash
apt install git curl build-essential libssl-dev zlib1g-dev
```
On CentOS/RHEL:
```bash
yum install openssl-devel zlib-devel
yum groupinstall "Development Tools"
```

Clone the repo:
```bash
git clone https://github.com/TelegramMessenger/MTProxy
cd MTProxy
```

To build, simply run `make`, the binary will be in `objs/bin/mtproto-proxy`:

```bash
make && cd objs/bin
```

If the build has failed, you should run `make clean` before building it again.

## Running
1. Obtain a secret, used to connect to telegram servers.
```bash
curl -s https://core.telegram.org/getProxySecret -o proxy-secret
```
2. Obtain current telegram configuration. It can change (occasionally), so we encourage you to update it once per day.
```bash
curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
```
3. Generate a secret to be used by users to connect to your proxy.
```bash
head -c 16 /dev/urandom | xxd -ps
```
4. Run `mtproto-proxy`:
```bash
./mtproto-proxy -u nobody -p 8888 -H 443 -S <secret> --aes-pwd proxy-secret proxy-multi.conf -M 1
```
... where:
- `nobody` is the username. `mtproto-proxy` calls `setuid()` to drop privilegies.
- `443` is the port, used by clients to connect to the proxy.
- `8888` is the local port. You can use it to get statistics from `mtproto-proxy`. Like `wget localhost:8888/stats`. You can only get this stat via loopback.
- `<secret>` is the secret generated at step 3. Also you can set multiple secrets: `-S <secret1> -S <secret2>`.
- `proxy-secret` and `proxy-multi.conf` are obtained at steps 1 and 2.
- `1` is the number of workers. You can increase the number of workers, if you have a powerful server.

Also feel free to check out other options using `mtproto-proxy --help`.

5. Generate the link with following schema: `tg://proxy?server=SERVER_NAME&port=PORT&secret=SECRET` (or let the official bot generate it for you).
6. Register your proxy with [@MTProxybot](https://t.me/MTProxybot) on Telegram.
7. Set received tag with arguments: `-P <proxy tag>`
8. Enjoy.

## Systemd example configuration
1. Create systemd service file (it's standart path for the most Linux distros, but you should check it before):
```bash
nano /etc/systemd/system/MTProxy.service
```
2. Edit this basic service (especially paths and params):
```bash
[Unit]
Description=MTProxy
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/MTProxy
ExecStart=/opt/MTProxy/mtproto-proxy -u nobody -p 8888 -H 443 -S <secret> -P <proxy tag> <other params>
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
3. Reload daemons:
```bash
systemctl daemon-reload
```
4. Test fresh MTProxy service:
```bash
systemctl restart MTProxy.service
# Check status, it should be active
systemctl status MTProxy.service
```
5. Enable it, to autostart service after reboot:
```bash
systemctl enable MTProxy.service
```

## Docker image
Telegram is also providing [official Docker image](https://hub.docker.com/r/telegrammessenger/proxy/).
>>>>>>> pr/4
