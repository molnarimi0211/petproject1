const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
require("dotenv").config();


const app = express();
const port = 3000;

app.use(cors());

const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
});


app.get("/api/games", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM games");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error during data fetch" });
  }
});

app.listen(port, () => {
  console.log(`Server is running at: http://localhost:${port}`);
});
