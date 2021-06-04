import mw from '../../../../src/mw.png'
const mql=window.matchMedia('(max-width: 960px)')
let mobileView=mql.matches

export const homeObjTwo={
    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:'About Us',
    description:`We are a startup, providing cloud based OCR solutions. For latest updates and offers , follow us on social media. `,
    imgStart:'start',
    img:mobileView ? "":mw,
    alt:'Image', 
    about:true
}

// export const homeObjFour={
//     lightbg:true,
//     lighttxt: false,
//     textdescription:false,
//     headline:"",
//     description:'"Assisting Humans in daily Life"',
//     imgStart:'',
//     img:'',
//     alt:'qr code'
// }