import express from "express"
import { RingApi, RingCamera } from 'ring-client-api'
import 'dotenv/config'
import nocache from 'nocache'

const app = express();
app.use(nocache())
app.disable('x-powered-by')
app.disable('etag')

const { env } = process
const port = 5005 || env.PORT
const ringSecret = env.ringSecret

const ringApi = new RingApi({
    refreshToken: ringSecret
});

const getBatteryInfo = async () => {
    try {
        return await ringApi.getCameras();
    } catch(err) {
        // TODO: log this
        return err
    }
}

app.get( "/get-battery", async ( req, res ) => {
    let batteryInfo:RingCamera[] = await getBatteryInfo()
    try {
        res.json(
            {   "batteryStatus": batteryInfo[0].batteryLevel,
                "batteryLow": batteryInfo[0].hasLowBattery,
                "error": null
            })
    } catch {
        res.json(
            {
                "batteryStatus": null,
                "batteryLow": null,
                "error": null
            }).status(500)
    }
} );

app.listen( port, () => {
    // TODO: log this
} );