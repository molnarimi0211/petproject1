import './Navbar.css';

const Navbar = () => {
  return (
    <nav className="navbar">
      <ul className="nav-list">
        <li className="nav-item"><a href="/" className="nav-link">Main</a></li>
        <li className="nav-item"><a href="about" className="nav-link">About</a></li>
        <li className="nav-item"><a href="games" className="nav-link">Games</a></li>
      </ul>
    </nav>
  );
};

export default Navbar;
