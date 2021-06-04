import React from 'react';
import { Button } from '../../Button';
import './Pricing.css';
import { FaFire } from 'react-icons/fa';
import { BsXDiamondFill } from 'react-icons/bs';
import { GiCrystalize } from 'react-icons/gi';
import { IconContext } from 'react-icons/lib';
import { Link } from 'react-router-dom';


function Pricing() {



  return (
    <IconContext.Provider value={{ color: '#fff', size: 64 }}>
      <div className='pricing__section'>
        <div className='pricing__wrapper'>
          <h1 className='pricing__heading'>API Pricing</h1>
          <div className='pricing__container'>
            <Link to='/form' className='pricing__container-card'>
              <div className='pricing__container-cardInfo'>
                <div className='icon'>
                  <FaFire />
                </div>
                <h3>Starter</h3>
                <h4>$400</h4>
                <p>per annum</p>
                <ul className='pricing__container-features'>
                  <li>10,000 requests per month.</li>
                  <li>No dedicated VPS instance.</li>
                  <li>No model customization.</li>
                </ul>
                <Button buttonSize='btn--wide' buttonColor='primary'>
                  Choose Plan
                </Button>
              </div>
            </Link>
            <Link to='/form' className='pricing__container-card' >
              <div className='pricing__container-cardInfo'>
                <div className='icon'>
                  <BsXDiamondFill />
                </div>
                <h3>Gold</h3>
                <h4>$600</h4>
                <p>per annum</p>
                <ul className='pricing__container-features'>
                  <li>No request limit.</li>
                  <li>Dedicated VPS instance.</li>
                  <li>No model customization.</li>
                </ul>
                <Button buttonSize='btn--wide' buttonColor='primary'>
                  Choose Plan
                </Button>
              </div>
            </Link>
            <Link to='/form' className='pricing__container-card'>
              <div className='pricing__container-cardInfo'>
                <div className='icon'>
                  <GiCrystalize />
                </div>
                <h3>Diamond</h3>
                <h4>$1000</h4>
                <p>per annum</p>
                <ul className='pricing__container-features'>
                  <li>No request limit.</li>
                  <li>Dedicated VPS instance.</li>
                  <li>Model will be customized, according to client dataset.</li>
                </ul>
                <Button buttonSize='btn--wide' buttonColor='primary'>
                  Choose Plan
                </Button>
              </div>
            </Link>
          </div>
        </div>
      </div>
    </IconContext.Provider>
  );
}
export default Pricing;