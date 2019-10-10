import React from 'react';
import { Button, Form, FormGroup, Input, Label } from 'reactstrap';
import { post, serialize } from '../utils/helper';

export default class FeedbackForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: '',
      comments: '',
      message: ''
    };
  }


  handleFormSubmit = (event) => {
    event.preventDefault();
    // this.setState({ message: 'waiting...' });
    const formParams = { name: this.state.name, comments: this.state.comments };
    return post('/api/feedbacks', serialize(formParams))
      .then(() => {
        this.setState({
          name: '',
          comments: '',
          message: 'Successfully Submitted'
        });
      })
      .catch(() => {
        this.setState({
          message: 'Failed to submit'
        });
      });
  };

  handleFormChange = (e) => {
    this.setState({ [e.target.name]: e.target.value });
  };

  render() {
    return (
      <div>
        <div className="js-message">{ this.state.message }</div>
        <Form onSubmit={this.handleFormSubmit}>
          <FormGroup>
            <Label>
              Your Name:
              <Input type="text" name="name" value={this.state.name} onChange={this.handleFormChange} />
            </Label>
          </FormGroup>
          <FormGroup>
            <Label>
              Comments:
              <Input type="textarea" name="comments" value={this.state.comments} onChange={this.handleFormChange} />
            </Label>
          </FormGroup>
          <Button>Submit</Button>
        </Form>
      </div>
    );
  }
}

