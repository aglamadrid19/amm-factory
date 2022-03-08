pragma solidity =0.5.16;

import './interfaces/IUffFactory.sol';
import './UffPair.sol';

contract UffFactory is IUffFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(UffPair).creationCode));
    
    address public feeTo;
    address public feeToSetter;

    // UFF MOD - ADDED WBNB - SWAP AND LIQUIDITY ROUTER
    address public wbnb;
    address public liquidityRouter;
    address public swapRouter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    bool public permissionless = false; 

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        if (!permissionless) {
            require(feeToSetter == msg.sender, "UFF: ONLY FEE TO SETTER");
        }
        require(tokenA != tokenB, "UFF: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "UFF: ZERO_ADDRESS");
        require(getPair[token0][token1] == address(0), "UFF: PAIR_EXISTS"); // single check is sufficient
        bytes memory bytecode = type(UffPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IUffPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UFF: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UFF: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function setWbnb(address _wbnb) external {
        require(msg.sender == feeToSetter, 'UFF: FORBIDDEN');
        wbnb = _wbnb;
    }

    function setSwapRouter(address _swapRouter) external {
        require(msg.sender == feeToSetter, 'UFF: FORBIDDEN');
        swapRouter = _swapRouter;
    }

    function setLiquidityRouter(address _liquidityRouter) external {
        require(msg.sender == feeToSetter, 'UFF: FORBIDDEN');
        liquidityRouter = _liquidityRouter;
    }

    function setPermissionless(bool _permission) external {
        require(msg.sender == feeToSetter, 'UFF: FORBIDDEN');
        permissionless = _permission;
    }
}