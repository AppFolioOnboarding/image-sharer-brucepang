import React from 'react';
import { Button, Form, FormGroup, Label, Input } from 'reactstrap';
import Header from './Header';

export default function App() {
  return (
    <div className="container">
      <Header title="Tell us what you think" />
      <Form>
        <FormGroup>
          <Label>
            Your Name:
            <Input type="text" name="name" />
          </Label>
        </FormGroup>
        <FormGroup>
          <Label>
            Comments:
            <Input type="textarea" name="comments" />
          </Label>
        </FormGroup>
        <Button>Submit</Button>
      </Form>
      <footer> Copyright: Appfolio Inc. Onboarding </footer>
    </div>
  );
}

/* TODO: Add Prop Types check*/
