// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address payable owner;
    IERC20 token;
    uint256 public withdrawAmount;
    uint256 public lockTime = 1 minutes;
    mapping(address => uint) nextAccessTime;
    event Deposit(address indexed from, uint256 indexed amount);
    event WithDraw(address indexed to, uint256 indexed amount);

    constructor(address tokenAddress) payable {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    // Request Tokens from faucet
    function requestTokens() public payable {
        require(msg.sender != address(0), "Invalid Account");
        require(
            token.balanceOf(address(this)) >= withdrawAmount,
            "Insufficient balance in faucet"
        );
        require(
            (block.timestamp >= nextAccessTime[msg.sender]),
            "To be fair with all developers,Wait for sometime to request more tokens"
        );
        token.transfer(msg.sender, withdrawAmount);
        nextAccessTime[msg.sender] = block.timestamp + lockTime;
    }

    // Set the Withdraw amount of faucet (ONLY OWNER)
    function setWithdrawAmount(uint256 _withdrawAmount) public onlyOwner {
        withdrawAmount = _withdrawAmount * (10 ** 18);
    }

    // Set the LockTime of faucet (ONLY OWNER)
    function setLockTime(uint256 _lockTime) public onlyOwner {
        lockTime = _lockTime * 1 minutes;
    }

    // Get the Balance of faucet
    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // WithDraw Tokens from faucet
    function withdrawToken() external payable onlyOwner {
        emit WithDraw(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    // Preload the faucet
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied");
        _;
    }
}
