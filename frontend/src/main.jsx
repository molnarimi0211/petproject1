import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider, createBrowserRouter } from 'react-router-dom';
//import './index.css'
import App from './App.jsx'
import About from './About.jsx'
import Fooldal from './Fooldal.jsx'
import Jatekok from './Jatekok.jsx';
import Navbar from './Navbar.jsx';

const router = createBrowserRouter([
  {
    path: '/',
    element: <Fooldal />
  },
  {
    path: '/about',
    element: <About />
  },
  {
    path: '/games',
    element: <Jatekok />
  }
])

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Navbar />
    <RouterProvider router={router} />
  </StrictMode>,
)
