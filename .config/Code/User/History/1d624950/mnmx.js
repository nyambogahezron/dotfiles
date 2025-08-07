const express = require("express");
// const sequelize = require('./utils/sequerize');
const db_async = require('./models/db_async'); 
const https = require("https");
const http = require("http");
const fs = require("fs");
const dotenv = require("dotenv");
const path = require("path");
const cors = require("cors");
const ip = require("ip");
const fileUpload = require("express-fileupload");
const RESPONSE_CODES = require("./constants/RESPONSE_CODES");
const RESPONSE_STATUS = require("./constants/RESPONSE_STATUS");
const marchantRouterProvider = require("./routes/qrCode/marchantRouterProvider");
const authRouterProvider = require("./routes/auth/authRouterProvider");
const bindUser = require("./middleware/bindUser");
const ecoRouterProvider = require("./routes/eco/ecoRouterProvider");
const paymentRouterProvider = require("./routes/payment/paymentRouterProvider");
const historyRouterProvider = require("./routes/history/historyRouterProvider");
const postsRouterProvider = require("./routes/posts/postsRouterProvider");
const adminsRouterProvider = require("./routes/admins/adminsRouter");
const requireAuth = require("./middleware/requireAuth");
const eventsRouterProvider = require("./routes/events/eventsRouterProvider");
const deviceTokensRouter = require("./routes/deviceTokens/deviceTokensRouter");
const app = express();

// Logging middleware to log all incoming requests with body
app.use((req, res, next) => {
  console.log(`Incoming request: ${req.method} ${req.url} body: ${JSON.stringify(req.body)}`);
  next();
});
dotenv.config({ path: path.join(__dirname, "./.env") });

app.use(cors());
app.use(express.static(__dirname + "/public"));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.all('*', bindUser)
app.use("/auth", authRouterProvider)
app.use("/qrcode", marchantRouterProvider)
app.use("/eco", ecoRouterProvider)
app.use("/payment", paymentRouterProvider)
app.use("/history",requireAuth, historyRouterProvider)
app.use("/posts", postsRouterProvider)
app.use("/admins", adminsRouterProvider);
app.use("/events", eventsRouterProvider)
app.use("/deviceTokens", deviceTokensRouter);

app.use('/', (req, res) => {
  res.status(RESPONSE_CODES.OK).json({
    statusCode: RESPONSE_CODES.OK,
    httpStatus: RESPONSE_STATUS.OK,
    message: "Welcome to Ecoderum API",
    result: [],
  });
});

app.all("*", (req, res) => {
  res.status(RESPONSE_CODES.NOT_FOUND).json({
    statusCode: RESPONSE_CODES.NOT_FOUND,
    httpStatus: RESPONSE_STATUS.NOT_FOUND,
    message: "Route non trouvé",
    result: [],
  });
});
const port = process.env.PORT || 8000;

app.listen(port, async () => {
  // await db_async.sequelize.sync({ force: true }); 
  console.log(
    `${process.env.NODE_ENV.toUpperCase()} - Server is running on: http://${ip.address()}:${port}/`
  );
});
