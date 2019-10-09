/* eslint-env mocha */

import assert from 'assert';
import { mount } from 'enzyme';
import React from 'react';
import App from '../../components/App';

describe('<App />', () => {
  it('should render correctly', () => {
    const wrapper = mount(<App />);
    assert(wrapper.contains('Tell us what you think'));
  });

  it('should have one input and one textarea', () => {
    const wrapper = mount(<App />);
    assert.strictEqual(wrapper.find('input').length, 1);
    assert.strictEqual(wrapper.find('textarea').length, 1);
  });

  it('should have a footer', () => {
    const wrapper = mount(<App />);
    assert.strictEqual(wrapper.find('footer').length, 1);
  });
});
