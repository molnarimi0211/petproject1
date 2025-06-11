import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider, createBrowserRouter } from 'react-router-dom';
import About from './About.jsx'
import Navbar from './Navbar.jsx';
import MainPage from './MainPage.jsx';
import Games from './Games.jsx';

const router = createBrowserRouter([
  {
    path: '/',
    element: <MainPage />
  },
  {
    path: '/about',
    element: <About />
  },
  {
    path: '/games',
    element: <Games />
  }
])

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Navbar />
    <RouterProvider router={router} />
  </StrictMode>,
)
