# Telegram MTProto Proxy (Official version fork)

## Credits

Check the original repo https://github.com/TelegramMessenger/MTProxy and it is preferred to use it than this one as this repo won't be much maintained.
But, of course, information from this fork can be useful too.

## Disclaimer

Please, in case of any issues while build or etc, create an issue on original [repo page](https://github.com/TelegramMessenger/MTProxy)! 

## Testing servers

Server #1. [https://t.me/proxy?server=gorilla.proxy.plez.me...](https://t.me/proxy?server=gorilla.proxy.plez.me&port=6968&secret=469fe09b277900a8ae91dcefa736056b) or click this for iOS tg://proxy?server=gorilla.proxy.plez.me&port=6968&secret=469fe09b277900a8ae91dcefa736056b

## Building, installation and setting a promoted channel

@todo: Add the tutorial

Below goes original tutorial from developer.

## Building, installation

to build, simply run 'make'. Your binary will be objs/bin/mtproto-proxy

to run mtproto-proxy:
  1. Obtain a secret, used to connect to telegram servers. 
  curl -s https://core.telegram.org/getProxySecret -o proxy-secret

  2. Obtail current telegram configuration. It can change (occasionally), so we encourage you to update it once per day.
  curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

  3. Generate a secret to be used by users to connect to your proxy
  head -c 16 /dev/urandom | xxd -ps

  4. Run mtproto-proxy
        mtproto-proxy -u nobody -p 8888 -H 443 -S <secret> --aes-pwd proxy-secret proxy-multi.conf -M 1
  where:
          - nobody is the user name. mtproto-proxy calls setuid() to drop privilegies
          - 443 is the port, used by clients to connect to the proxy
          - 8888 is the local port. You can use it to get statistics from mtproto. Like wget localhost:8888/stats
            You can only get this stat via loopback
          - <secret> is the secret generated at step 3. 
          - proxy-secret and proxy-multi.conf are obtained at steps 1 and 2
          - 1 is the number of workers. You can increase the number of workers, if you have a powerful server
          - also feel free to check out other options using mtproto-proxy help 
             

  5. generate the  link tg://proxy?server=SERVER_NAME&port=443&secret=SECRET

  6.  register your proxy with @MTProxybot on Telegram.

  7. enjoy
