import React, { useState, useEffect } from "react";
import "./Jatekok.css";

const GameCard = ({ title, description, image }) => (
  <div className="game-card">
    <img src={image} alt={title} className="game-image" />
    <h3 className="game-title">{title}</h3>
    <p className="game-description">{description}</p>
  </div>
);

const Jatekok = () => {
  const [games, setGames] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const apiUrl = import.meta.env.VITE_API_URL || "http://backend.kopefalva.svc.cluster.local:3000";

  useEffect(() => {
    const fetchGames = async () => {
      try {
        const response = await fetch(`${import.meta.env.VITE_API_URL}/api/games`);
        if (!response.ok) {
          throw new Error("Hiba történt az adatok lekérésekor.");
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

  if (loading) return <p>Adatok betöltése...</p>;
  if (error) return <p>Hiba történt: {error}</p>;

  return (
    <div className="game-page">
      <h1 className="game-header">JÁTÉKAINK</h1>
      <div className="game-grid">
        {games.map((game, index) => (
          <GameCard key={index} {...game} />
        ))}
      </div>
    </div>
  );
};

export default Jatekok;
