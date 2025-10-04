const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
const client = require('prom-client');
require("dotenv").config();

const collectMetrics = client.collectDefaultMetrics;
collectMetrics();

const app = express();
const port = 3000;

app.use(cors());
const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: 5432,
  ssl: {
    rejectUnauthorized: false,
  },
});

pool.connect(async (err, client, release) => {
  if (err) {
    return console.error("Error connecting to the database:", err.stack);
  }
  console.log("Successfully connected to the database!");
//});


  try {
    const result = await client.query("SELECT * FROM games");
    console.log("Data fetched on successful connection:");
    console.log(result.rows);
  } catch (queryErr) {
    console.error("Error fetching data immediately after connection:", queryErr);
  } finally {
    release(); 
  }
});

app.get('/metrics', (req, res) =>{
  res.set('Content-Type', client.register.contentType);
  res.send(client.register.metrics());
})


app.get("/api/games", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM games");
    res.json(result.rows);
  } catch (err) {
    console.error("Error running query:", err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server is running at: http://localhost:${port}`);
});