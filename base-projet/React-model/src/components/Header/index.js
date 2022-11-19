import { useSelector } from 'react-redux';
import './style.scss';

const Header = () => {
  const hello = useSelector((state) => state.hello);
  return (
    <h1>{hello}</h1>
  );
};

export default Header;

