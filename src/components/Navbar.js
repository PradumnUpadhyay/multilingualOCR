import React, { useState } from "react"
import { Link } from "react-router-dom";
import { FaBars, FaTimes } from "react-icons/fa";
import "./Navbar.css"
import { IconContext } from "react-icons/lib"
import logo from '../mw.png'

export default function Navbar() {
const [clicked, onclick] = useState(false) // initial state
const listen=() => onclick(!clicked)
const mobileMenu=() => onclick(false)

    return (
           <>
            <IconContext.Provider value={{color: '#fff' }}>

            <div className="navbar">
                <div className="navbar-container container">
                    <Link to="/" className="navbar-logo" onClick={mobileMenu}>
                        <img src={logo} alt="Logo" className="navbar-icon" />
                    MATOWORK
                    </Link>

                    <div className="menu-icon" onClick={listen}>
                    {clicked ? <FaTimes/> : <FaBars/>}
                    </div>

                    <ul className={clicked ? 'nav-menu active' : "nav-menu"}>
                        <li className="nav-item">
                            <Link to='/' className="nav-links" onClick={mobileMenu}>
                            Home
                            </Link>
                        </li>
                        <li className="nav-item">
                            <Link to='/about' className="nav-links" onClick={mobileMenu}>
                            About
                            </Link>
                        </li>
                        <li className="nav-item">
                            <Link to='/products' className="nav-links" onClick={mobileMenu}>
                            Products
                            </Link>
                        </li>
                        <li className="nav-item">
                            <Link to='/pricing' className="nav-links" onClick={mobileMenu}>
                            Pricing
                            </Link>
                        </li>
                    </ul>
                </div>
            </div>
            </IconContext.Provider>
            </>
    )
}