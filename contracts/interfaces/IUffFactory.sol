pragma solidity >=0.5.0;

interface IUffFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    
    // UFF MOD - UPDATING INTERFACE
    function wbnb() external view returns (address);
    function swapRouter() external view returns (address);
    function liquidityRouter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    // UFF MOD - UPDATING INTERFACE SETTERS
    function setWbnb(address) external;
    function setSwapRouter(address) external;
    function setLiquidityRouter(address) external;
}
