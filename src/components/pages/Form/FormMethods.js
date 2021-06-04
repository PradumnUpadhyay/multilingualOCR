import React from 'react'


const FormMethods = (callback, validate) => {

    const [errors, setErrors]=React.useState({})
    const [isSubmitting, setIsSubmitting]=React.useState(false)

     const [values, setValues] = React.useState({
         name:'',
         email:'',
         plan:'',
         country:''
     })

 const handleChange=e=>{
     const {name, value}=e.target
     setValues({
         ...values,
         [name]: value
     })   
 }


 const handleSubmit=e=>{
     e.preventDefault()
     setErrors(validate(values))
     setIsSubmitting(true)    
 }

 React.useEffect(
     () => {
       if (Object.keys(errors).length === 0 && isSubmitting) {
         callback()
      
    
            const options={
                method:'POST',
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(values)
            }
        
            fetch('https://matowork.com/users/form', options).then(res => console.log(res.json()))
     
       }
     },
     [errors]
   );
   return { handleChange, handleSubmit, values, errors };

}

export default FormMethods
