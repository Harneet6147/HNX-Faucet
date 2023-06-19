// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract HarnixToken is ERC20Capped {
    address payable public owner;
    uint256 public blockReward;

    constructor(
        uint256 _cap,
        uint256 _blockReward
    ) ERC20("Harnix", "HNX") ERC20Capped(_cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 9000 * (10 ** decimals()));
        blockReward = _blockReward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped) {
        require(
            ERC20.totalSupply() + amount <= cap(),
            "ERC20Capped: cap exceeded"
        );
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function setBlockReward(uint256 _blockReward) public onlyOwner {
        blockReward = _blockReward;
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _amt
    ) internal virtual override {
        if (
            _from != address(0) &&
            _to != block.coinbase &&
            block.coinbase != address(0)
        ) {
            _mintMinerReward();
        }

        super._beforeTokenTransfer(_from, _to, _amt);
    }

    // function destroy() public onlyOwner {
    //     selfdestruct(owner);
    // }

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied");
        _;
    }
}
