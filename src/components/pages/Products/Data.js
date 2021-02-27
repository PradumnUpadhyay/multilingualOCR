import logo from '../../../../src/logo.png'
import ss5 from '../../../../src/ss5.png'
import ss2 from '../../../../src/ss2.png'
import ss3 from '../../../../src/ss3.png'
import ss4 from '../../../../src/ss4.png'

export const description={
    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:'Multilingual OCR',
    description:
        <p className="home-subtitle dark">Multilingual OCR (Optical Character Recognition), is an app that converts the extracted text from images to docx format, meaning you can open the converted file using Google docs. Currently this app supports 9 different languages:
	</p>
   
       ,
    imgStart:'',
    img: logo,
    product: true,
    desc: true
}

export const step1={

    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:'User Guidelines',
    description:<div>
        <p className="home-subtitle dark">Signup or Login into your account and you will be displayed with the following welcome screen</p>
        <ul>
            <li>
            <p className="home-subtitle dark"> You can upgrade, logout, or check your remaining active days and page limit in your side menu. </p>
            </li>
        </ul>
        
    </div>,
    imgStart:'start',
    img:ss2,
    alt:'qr code',
    steps: true
}

export const step2={
    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:'Step 1',
    description:<p className="home-subtitle dark">
        To create a new Document click on the button at bottom, you will be prompted to enter the filename with which you want to create your document as shown in the figure alongside 
        <br/>
        <br/>
        <span className="mini-para">(Note that you cannot have an underscore(_) in your filename).</span>
    </p>,
    imgStart:'start',
    img:ss5,
    alt:'qr code',
    steps: true
}

export const step3={
    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:'Step 2',
    description:<div className="stpe3">
        <p className="step3">Multilingual app uses batch mode for supporting multiple languages in a single document.Now, on the document creation page, you can add multiple images using a gallery or camera <br/>
        <br/>
        <ul>
        <li>In the gallery mode, you can enter batch or multiple selection mode by longpressing on an image.</li>
        <br/>
        <li>In camera mode, you can click multiple images at the same time.</li>
        <br/>
        <li>After adding all the images( it is possible to add photos from the gallery and camera in the same batch), you have to select the languages for this batch. After selecting languages, you can create a new batch by clicking on the camera or gallery icon.</li>
        <br/>
        <li>Note that all the images added in a batch are displayed under the Image section</li>
        <br/>
        <li>Note that once a batch is created, no further changes can be done.</li>
        <br/>
        <li>For cropping the images, click on the image for editing it.</li>
        <br/>
        <li>For deleting an image, long press on that image and you will get the delete button on the top left corner of screen.</li>
        <li>It is recommended to put the same language images in a single batch and create a new batch for another language.</li>
        <li>After creating the last batch click on convert for starting the ocr service. </li>
        </ul>
        </p>
        </div>,
    imgStart:'start',
    img:ss3,
    alt:'qr code',
    steps: true
}

export const step4={
    lightbg:true,
    lighttxt: false,
    textdescription:false,
    headline:'Step 3',
    description:<div>
        <p className="home-subtitle dark">
	Once a document is created, you will be redirected to the welcome screen, where you can view your created doc.</p>
    <p className="mini-para">(Note that if you haven't installed Google Docs, you will be redirected to play store from where you can install it.)</p>
    </div>,
    imgStart:'start',
    img:ss4,
    alt:'qr code',
    steps: true
}
