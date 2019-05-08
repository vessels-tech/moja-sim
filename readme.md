# Moja-Sim

A mojaloop simulator that talks to a running mojaloop deployment.

At this stage, we are using the `mojaloop/simulator` project, but I don't really understand what it does. 
I'm just going to spend some time trying to figure out what the simulator does, and see if we can hook it up
to our mojaloop deployment


## Installing the Simulator

Run the container:

```bash
docker-compose up
```

Talk to the container:
```bash
curl localhost:8444/health
```

Open the swagger docs:
```bash
open http://localhost:8444/documentation
```

## Talking to Mojaloop

Ok. Now we need to get the simulator to talk to our running mojaloop instance.

It doesn't look like the `/payer/**` endpoint really does anything. But there is a lot of implementation
in `/payee` which looks like it actually talks to Mojaloop


### /parties

Lets try out the parties endpoints, specifically:

```
GET /payeefsp/parties/{type}/{id}
POST /payeefsp/parties/{type}/{id}
```

```bash
#Create a Party - I think this is cached locally only
#originally from OSS-New-Deployments Postman Collection

curl -X POST \
  http://localhost:8444/payeefsp/parties/MSISDN/27713803912 \
  -H 'Content-Type: application/json' \
  -d '{
    "party": {
        "partyIdInfo": {
            "partyIdType": "MSISDN",
            "partyIdentifier": "27713803912",
            "fspId": "payeefsp"
        },
        "name": "Siabelo Maroka",
        "personalInfo": {
            "complexName": {
                "firstName": "Siabelo",
                "lastName": "Maroka"
            },
            "dateOfBirth": "3/3/1973"
        }
    }
}'




#Get a Party 
DATE=$(echo 'nowDate = new Date(); console.log(nowDate.toGMTString());' > /tmp/date && node /tmp/date)


curl -X GET http://localhost:8444/payeefsp/parties/MSISDN/27713803912 \
  -H 'fspiop-source: payerfsp' \
  -H "date: $DATE"
```

We first needed to add the `Host` header in order to talk to our ML deployment. 
In the future we will fix this, but this will do for now.


I think we will need to expose our endpoints using localtunnel or something, so that Mojaloop can respond to the simulator correctly.



