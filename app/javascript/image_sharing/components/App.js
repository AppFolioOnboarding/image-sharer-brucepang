import React from 'react';
import Footer from './Footer';
import Header from './Header';
import FeedbackForm from './FeedbackForm';


export default function App() {
  return (
    <div className="container">
      <Header title="Tell us what you think" />
      <FeedbackForm />
      <Footer>Copyright: Appfolio Inc. Onboarding</Footer>
    </div>
  );
}

/* TODO: Add Prop Types check*/
