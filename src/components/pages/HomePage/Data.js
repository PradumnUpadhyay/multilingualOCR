import logo from '../../../../src/qr-code.png'
import logo1 from '../../../../src/logo.png'

const mql=window.matchMedia('(max-width: 960px)')
let mobileView=mql.matches
console.log(mobileView)

export const homeObjOne={
    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:
    "",
    description: mobileView ? 
    <img src={logo1} alt="banner" className="mobile"/>

 : "",
    imgStart:'',
    img:logo,
    alt:"alt",
    home: true
}
