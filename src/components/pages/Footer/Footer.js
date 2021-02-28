import React from 'react';
import './Footer.css';
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
        
        <div className='footer-link-items contacts'>
            <h2>Contact Us</h2>
            support@matowork.com
           
          </div>
       
          
          <div className='footer-link-items social-media media'>
            <h2>Social Media</h2>
            <a rel="noreferrer" href='https://www.facebook.com/matowork.products'>Facebook</a>
            <a rel="noreferrer" href='https://www.instagram.com/matowork.products/'>Instagram</a>
            <a rel="noreferrer" href='https://www.linkedin.com/company/matowork'>LinkedIn</a>
           
          </div>
        </div>
      </div>
      <section className='social-media'>
        <div className='social-media-wrap'>
          <div className='footer-logo'>
          <a rel="noreferrer" className="footer-link-items policies" href='https://raw.githubusercontent.com/Matowork/Multilingualocr/main/PrivacyPolicy'>Privacy Policy</a> 
                 
         <a rel="noreferrer"  className="footer-link-items policies" href='https://raw.githubusercontent.com/Matowork/Multilingualocr/main/TermOfService'>Terms and Services</a>
                
          </div>
          <small className='website-rights'>MATOWORK &copy; 2021</small>
          <div className='social-icons'>
            <a
              className='social-icon-link'
              href='https://www.facebook.com/matowork.products'
              target='_blank'
              rel="noreferrer"
              aria-label='Facebook'
            >
              <FaFacebook />
            </a>
            <a
              className='social-icon-link'
              href='https://www.instagram.com/matowork.products/'
              rel="noreferrer"
              target='_blank'
              aria-label='Instagram'
            >
              <FaInstagram />
            </a>
           
    
            <a
              className='social-icon-link'
              href='https://www.linkedin.com/company/matowork'
              rel="noreferrer"
              target='_blank'
              aria-label='LinkedIn'
            >
              <FaLinkedin />
            </a>
          </div>
        </div>
      </section>
    </div>
  );
}

export default Footer;