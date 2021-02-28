import React from "react";
import "./Section.css"
import banner from "../logo.png"
import { Link } from "react-router-dom";

const mql=window.matchMedia('(max-width: 960px)')
let mobileView=mql.matches
console.log(mobileView)

export default function Section( {
    lightbg, lighttxt, textdescription, headline, description, img, alt, imgStart, about, home, product, steps, desc
}) {
return (
    <>
    <div className={lightbg ? 'home-section':'home-section darkbg'}>
        <div className="contianer">
            <div className="row home-row" 
            style={{display:'flex', flexDirection: imgStart === 'start' ? 'row-reverse':'row'}}>
            <div className="col">
                <div className="home-text-wrapper">
                   
                    <h1 className={lighttxt ? 'heading':'heading dark'} id={desc ? "desc-heading" : ""}>
                        {  home===true && !mobileView ? <div className="banner home-img-wrapper">
                                <img src={banner} alt="banner" className="home-img"/>
                            </div>
                              : 
                            
                           headline
                        } 
                        </h1>

                        <p className={textdescription ? 'home-subtitle' : 'home-subtitle dark'}>
                            {
                                home===true && !mobileView ?   <span className="col" id="img-subheading">Multilingual OCR</span>   
                                :
                                description} <br/> {
                            about===true ? <p className="mini-para">(links are provided at bottom of this page)</p>
                        :
                        product ? <div className="languages home-subtitle ">

                        <ul className="home-subtitle dark">
                            <li>Hindi</li>
                            <li>Sanskrit</li>
                            <li>English</li>
                            <li>German</li>
                            <li>French</li>
                            <li>Spanish</li>
                            <li>Hebrew</li>
                            <li>Japanese</li>
                            <li>Arabic</li>
                        </ul> 
                        </div> :
                        steps ? "" :""
                        } 
                            
                        </p>

                        {about===true ? <p className={textdescription ? 'home-subtitle' : 'home-subtitle dark'}>
                            <span className="vision-heading"> Vision</span>
                             <br/> 
                             <span className="vision-text">Assisting Humans in daily life </span>
                             </p> :
                              ""}

                    
                </div>
            </div>
            {
            home===true && !mobileView ?
            // <div className="col" >
             <div className="home-text-wrapper"> 
                <Link to="/products" className="home-text-wrapper btn-primary" >Know more</Link>
                <br />
                <br />
                <br />
                <br />
                <Link to="https://matowork.com/download" className="home-text-wrapper btn btn-primary" >Download App</Link>
                 </div> 
            // </div>
             : ""
             }    

            <div className="col">
                <div className="home-img-wrapper qr-code">
                   
                   { mobileView && home? <div className="btn">
                       <div>
                       <Link to="/products" className=" btn-primary info" >Know more</Link>
                       </div>
                       <div>
                       <a href="https://matowork.com/donwload" className="btn-primary">Download App</a> 
                       </div>
                  
                    
                   </div>:  
                   img!=='' ?<div>
                       <img src={img} alt={alt} className="home-img qr-code"/>
                       {
                       home && !mobileView ? <p id="qr-subheading"> Scan the QR code to download the App</p> : "" 
                       }
                       </div>  : ""}
                </div>
            </div>
            </div>
        </div>
    </div>
    </>
)
}

