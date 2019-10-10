import PropTypes from 'prop-types';
import React from 'react';

export default function Footer(props) {
  return (
    <footer>
      {props.children}
    </footer>
  );
}

Footer.propTypes = {
  children: PropTypes.string.isRequired
};
