import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import ArticlePage from './Pages/ArticlePage';
import NotFoundPage from './Pages/NotFoundPage';

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/" component={() => <div>Home Page</div>} />
        <Route path="/article/:id" component={ArticlePage} />
        <Route component={NotFoundPage} />
      </Switch>
    </Router>
  );
}

export default App;