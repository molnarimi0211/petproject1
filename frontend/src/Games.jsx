import React, { useState, useEffect } from "react";
import "./Games.css";

const GameCard = ({ title, description, image }) => (
  <div className="game-card">
    <img src={image} alt={title} className="game-image" />
    <h3 className="game-title">{title}</h3>
    <p className="game-description">{description}</p>
  </div>
);

const Games = () => {
  const [games, setGames] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const apiUrl = import.meta.env.VITE_API_URL || "http://backend.kopefalva.svc.cluster.local:3000/api/games";

  useEffect(() => {
    const fetchGames = async () => {
      try {
        const response = await fetch(`${import.meta.env.VITE_API_URL}/api/games`);
        if (!response.ok) {
          throw new Error("Error during data fetch.");
        }
        const data = await response.json();
        setGames(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchGames();
  }, []);

  if (loading) return <p>Loading data...</p>;
  if (error) return <p>Error occured: {error}</p>;

  return (
    <div className="game-page">
      <h1 className="game-header">Games</h1>
      <div className="game-grid">
        {games.map((game, index) => (
          <GameCard key={index} {...game} />
        ))}
      </div>
    </div>
  );
};

export default Games;
