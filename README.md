# RingDoorbellWidget
IOS 14 Swift Widget to show Ring doorbell battery % and health.

## Getting started

```bash
git clone https://github.com/jusso-dev/RingDoorbell-IOSWidget
```

### Server 

```bash
cd /src/server
npm i
npm start

OR 

docker build . -t doorbell-api
docker run -p 5005:5005 -d doorbell-api
```

### Client 

```bash
cd /src/client
open xcode project file
run xcode on emulator or device
```