This a container based on Alpine Linux running the TCPSER modem emulator.

[TCPSER is a modem emulator](https://github.com/FozzTexx/tcpser), it emulates a Hayes compatible modem. It allows to connect an older system via a null-modem cable to services, like BBSes
This container also has PPP preconfigured to simulate a dialup ISP provider and connect to internet.

It uses Alpine with TCPSER, PPP and Dnsmasq.

[Based on the PiModem project by PodSix,](http://podsix.org/articles/pimodem/) which uses a Raspberry Pi Zero W.

## Features

* It uses the TCPSER fork by FozzTexx.
* Includes PPP preconfigured to simulate a dialup ISP provider.
* The PPP service accepts any username and password.
* Uses Dnsmasq to share the host's DNS resolver.

## Requirements

* A retro computer with a serial port.
* A modern computer running docker with a serial port, or [an USB serial adapter](https://en.wikipedia.org/wiki/File:FTDI_USB_SERIAL.jpg).
* A [null modem cable](https://en.wikipedia.org/wiki/Null_modem).

## How to build

```shell
git clone https://github.com/chris-l/docker-tcpser-modem-emulator.git
cd docker-tcpser-modem-emulator

docker build -t tcpser-modem-emulator .
```

## Environment variables

* `DEV`: The serial device. Default: `/dev/ttyS0`
* `BAUD`: The baud rate to use. Default: `38400`

For the fake Dialup internet provider, there are these additional variables available:

* `IP_SERVER`: The IP assigned to the server. Default: `10.0.1.1`
* `IP_CLIENT`: The IP assigned to the client. Default: `10.0.1.2`
* `PPP_PHONE`: The phone number to use. Default: `5559000`
* `PROXY`: Optional. Redirect to a proxy any request to port 80. It must be set in the `IP:PORT` format, like `172.17.0.1:8000`. Unset by default.

## Volumes

* `/dev/<your serial device>`: The serial device to be used. Normally is /dev/ttyUSB0 for USB adapters. /dev/ttyS0 would be the first serial device (what would be "com1" on Windows)
* `/phonebook.txt`: File containing lines in the format `<phone number>=<ip/domain>:<port>`. Example: `1701=bbs.fozztexx.com:23`

## Usage

**The argument `--privileged` is required to allow the container to access the serial device.**

In this example, its assuming the serial device is `/dev/ttyUSB0`, 115200 baud, a phonebook.txt file in the current directory and using `--rm` to remove the container after its closed.

```shell
docker run -it --rm --privileged -e BAUD=115200 -e DEV=/dev/ttyUSB0 -v /dev/ttyUSB0:/dev/ttyUSB0 -v $(pwd)/phonebook.txt:/phonebook.txt chrll/tcpser-modem-emulator
```

On the client, make sure to select the same baud as the container.

For the fake dialup provider, use the `PPP_PHONE` number. Any combination of username and password will work. For using a proxy, ideally use the client's browser settings to configure it. That way it can handle other request than those to port 80. If that is not possible, you can use the `PROXY` env var to redirect all port 80 requests through it.
