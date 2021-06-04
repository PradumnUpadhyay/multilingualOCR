import React from 'react'
import Section from '../../Section'
import {api,description, step1, step2, step3, step4} from './Data'


export default function Home() {
    return (
        <>
        <Section {...api} />
        <Section {...description} />
        <Section {...step1} />
        <Section {...step2} />
        <Section {...step3} />
        <Section {...step4} />
      
        </>
    )
}