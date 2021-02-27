import React from 'react';
import './Footer.css';
import { Link } from 'react-router-dom';
import {
  FaFacebook,
  FaInstagram,
  FaLinkedin
} from 'react-icons/fa';

function Footer() {
  return (
    <div className='footer-container'>
      
      <div className='footer-links'>
        
        <div className='footer-link-wrapper'>
        <div className='footer-link-items policies'>   
           <Link to='https://raw.githubusercontent.com/Matowork/Multilingualocr/main/PrivacyPolicy'>Privacy Policy</Link>       
        <Link to='https://raw.githubusercontent.com/Matowork/Multilingualocr/main/TermOfService'>Terms and Services</Link>
        </div>
        <div className='footer-link-items'>
            <h2>Contact Us</h2>
            <Link to='/'>support@matowork.com</Link>
           
          </div>
       
          
          <div className='footer-link-items'>
            <h2>Social Media</h2>
            <Link to='https://www.facebook.com/matowork.products'>Facebook</Link>
            <Link to='https://www.instagram.com/matowork.products/'>Instagram</Link>
           
          </div>
        </div>
      </div>
      <section className='social-media'>
        <div className='social-media-wrap'>
          <div className='footer-logo'>
            <Link to='/' className='social-logo'>
             
              MATOWORK
            </Link>
          </div>
          <small className='website-rights'>MATOWORK &copy; 2021</small>
          <div className='social-icons'>
            <Link
              className='social-icon-link'
              to='https://www.facebook.com/matowork.products'
              target='_blank'
              aria-label='Facebook'
            >
              <FaFacebook />
            </Link>
            <Link
              className='social-icon-link'
              to='https://www.instagram.com/matowork.products/'
              target='_blank'
              aria-label='Instagram'
            >
              <FaInstagram />
            </Link>
           
    
            <Link
              className='social-icon-link'
              to='https://www.linkedin.com/company/matowork'
              target='_blank'
              aria-label='LinkedIn'
            >
              <FaLinkedin />
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}

export default Footer;