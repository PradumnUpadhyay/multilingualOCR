import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import './App.css';
import About from './components/pages/About/About';
import Home from './components/pages/HomePage/Home';
import Products from './components/pages/Products/Products';
import Pricing from './components/pages/API-Pricing/Pricing'
import Form from './components/pages/Form/Form'
import Navbar from './components/Navbar';
import Footer from './components/pages/Footer/Footer';

function App() {
  return (
    <Router>
      <Navbar/>
      <Switch>
      <Route path='/' exact component={Home}/>
      <Route path='/about' exact component={About}/>
      <Route path='/products' exact component={Products}/>
      <Route path='/pricing' exact component={Pricing}/>
      <Route path='/form' exact component={Form}/>
      </Switch>
      <Footer />
    </Router>
  );
}

export default App;
