import React from 'react'
import './Form.css'
import FormSuccess from './FormSuccess'
import FormData from './FormData'

export default function Form() {

       const [isSubmitted, setIsSubmitted]=React.useState(false)

        console.log(isSubmitted)
       function submitForm() {

           setIsSubmitted(true)
       }

    return (
    <>
        <div className='form-container'>
        

      
        {!isSubmitted ? (
            <FormData submitForm={submitForm} />
        ) : (
            <FormSuccess />
        )}

        </div>
    </>
    )
}
