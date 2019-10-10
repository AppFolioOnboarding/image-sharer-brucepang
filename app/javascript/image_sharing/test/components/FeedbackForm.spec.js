/* eslint-env mocha */

import assert from 'assert';
import { mount } from 'enzyme';
import React from 'react';
import sinon from 'sinon';
import FeedbackForm from '../../components/FeedbackForm';
import * as helper from '../../utils/helper';

describe('<FeedbackForm />', () => {
  it('should have one input and one textarea', () => {
    const wrapper = mount(<FeedbackForm />);
    assert.strictEqual(wrapper.find('input').length, 1);
    assert.strictEqual(wrapper.find('textarea').length, 1);
  });

  describe('onSubmit', () => {
    let sandbox;

    beforeEach(() => {
      sandbox = sinon.createSandbox();
    });

    afterEach(() => {
      sandbox = sandbox.restore();
    });

    it('show success when request succeeds', () => {
      const component = mount(<FeedbackForm />);
      component.setState({
        name: 'name',
        comments: 'comments'
      });

      const stub = sandbox.stub(helper, 'post');
      stub.returns(Promise.resolve());

      component.instance().handleFormSubmit({
        target: { elements: [{ name: 'name', value: 'name' }, { name: 'comments', value: 'comments' }] },
        preventDefault: () => {}
      }).then(() => {
        assert(stub.calledWith('/api/feedbacks', 'name=name&comments=comments'));
        assert.strictEqual(component.state().message, 'Successfully Submitted');
        assert.strictEqual(component.find('.js-message').text(), 'Successfully Submitted');
        assert.strictEqual(component.state().name, '');
        assert.strictEqual(component.state().comments, '');
      });
    });

    it('show failure when request fails', () => {
      const component = mount(<FeedbackForm />);
      component.setState({
        name: 'name',
        comments: 'comments'
      });

      const stub = sandbox.stub(helper, 'post');
      stub.returns(Promise.reject());

      component.instance().handleFormSubmit({
        target: { elements: [{ name: 'name', value: 'name' }, { name: 'comments', value: 'comments' }] },
        preventDefault: () => {}
      }).then(() => {
        assert.strictEqual(component.state().message, 'Failed to submit');
        assert.strictEqual(component.find('.js-message').text(), 'Failed to submit');
        assert.strictEqual(component.state().name, 'name');
        assert.strictEqual(component.state().comments, 'comments');
      });
    });
  });
});
