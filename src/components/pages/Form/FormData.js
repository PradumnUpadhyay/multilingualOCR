import React from 'react'

import FormMethods from './FormMethods'
import validateInfo from './validaiton'
import ListItems from '../../Dropdown'

const FormData = ({ submitForm }) => {

    const { handleChange, handleSubmit, values, errors } = FormMethods( submitForm, validateInfo)
    const { plans,country }=ListItems

    const plan=plans.map(pl=><option value={pl}>{pl}</option>)
    const cntry=country.map(c=><option value={c}>{c}</option>)
    return (
        <>
        
        {/* <div className='form-content-right'> */}
       <form className="form" onSubmit={handleSubmit}>
           <h1>
               Registration
           </h1>

           <div className="form-inputs">
               <label htmlFor="name"
               className="form-label">
                  Name:
                   </label>
                   <input
                   id="name"
                   type='text'
                   name='name'
                   className="form-input"
                   value={values.name}
                   onChange={handleChange}
                    placeholder="Enter your Name" />
                    {errors.name && <p>{errors.name}</p>}
           </div>
           <div className="form-inputs">
               <label htmlFor="email"
               className="form-label">
                  Email: 
                   </label>
                   <input
                   id="email"
                   type='text'
                   name='email'
                   className="form-input"
                   value={values.email}
                   onChange={handleChange}
                    placeholder="Enter your Email" />
                    {errors.email && <p>{errors.email}</p>}
           </div>
           <div className="form-inputs">
               <label htmlFor="plan"
               className="form-label">
                  Plans:
                   </label>
                   <select id="plan" name="plan" onChange={handleChange} className="form-input" >
           {plan}
          </select>
          {errors.plan && <p>{errors.plan}</p>}
           </div>
           <div className="form-inputs">
               <label htmlFor="country"
               className="form-label">
                 Country:
                   </label>
                   <select id="country" name="country" className="form-input" onChange={handleChange}>
            {cntry}
        
          </select>
          {errors.country && <p>{errors.country}</p>}
           </div>
           <button className='form-input-btn' type='submit'>Submit</button>
           
         </form>
       {/* </div> */}
    </>
    )
}

export default FormData
