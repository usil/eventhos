require("dotenv").config();
const express = require("express");

const createServer = () => {
  let parsedReq = {};
  const calledTimes = [];
  let timesCalled = 0;
  var receivedBodyOfCustomLogic;

  const app = express();

  app.use(express.urlencoded({ extended: true }));
  app.use(express.json());

  app.post("/token", (req, res) => {
    const { grant_type, client_id, client_secret } = req.body;

    if (!grant_type && !client_id && !client_secret) {
      return res.status(400).json({
        message: "Incorrect grant type",
      });
    }

    return res.json({
      content: {
        access_token: "token_021",
      },
    });
  });

  app.post("/integration", (req, res) => {
    timesCalled++;
    calledTimes.push(new Date().getTime());
    parsedReq = {
      query: { ...req.query },
      headers: { ...req.headers },
      body: { ...req.body },
      calledTimes,
      timesCalled,
    };
    return res.json({
      message: "Ok",
    });
  });

  app.get("/integration", (_req, res) => {
    return res.json({
      content: parsedReq,
    });
  });

  app.get("/clean", (_req, res) => {
    parsedReq = {};
    calledTimes.length = 0;
    timesCalled = 0;
    return res.json({ message: "cleanup completed" });
  });

  app.post("/error", (_req, res) => {
    res.status(500);
    return res.json({ message: "error" });
  })

  app.post("/custom-logic", (_req, res) => {
    receivedBodyOfCustomLogic = _req.body
    return res.json({code:200});
  });

  app.get("/custom-logic", (_req, res) => {
    return res.json({content:receivedBodyOfCustomLogic});
  });

  return app;
};

const PORT = process.env.PORT || 1000;

createServer().listen(PORT, () => {
  console.log(`Test server ready on: http://localhost:${PORT}`);
});
