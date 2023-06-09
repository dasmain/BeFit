import app from "./server.js"
import mongodb from "mongodb"
import dotenv from "dotenv"
import UsersDAO from './dao/userDAO.js'
import StepsDAO from "./dao/stepsDAO.js"
import BodyMeasureDAO from "./dao/bodymeasurements_DAO.js"
import SleepDAO from "./dao/sleepDAO.js"

dotenv.config()

const MongoClient = mongodb.MongoClient

const port = process.env.PORT || 8000

MongoClient.connect(
    process.env.MONGO_DB_URI,
    {
        maxPoolSize: 50,
        wtimeoutMS: 2500,
        useNewUrlParser: true
    }
)
.catch(err => {
    console.error(err.stack)
    process.exit(1)
})
.then(async client => {
    await StepsDAO.injectDB(client)
    await UsersDAO.injectDB(client)
    await BodyMeasureDAO.injectDB(client)
    await SleepDAO.injectDB(client)
    app.listen(port, () => {
        console.log(`listening on port ${port}`)
    })
})
