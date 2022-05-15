// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {
    // the staker recieves 1 gwei for every token staked per second
    uint256 public REWARDRATE
    constructor() ERC20("RewardToken", "RT") {
        _mint(msg.sender, 1000000000000000000000000000);
        REWARDRATE = 1
    }
    function setRewardRatePS(uint256 _rate) public onlyOwner {
        require(_rate > 1, "1 gwei is the smallest unit of Measurement")
        REWARDRATE = _rate
    }
    function rewardTokensPS(uint256 _amount, uint256 memory _timeTaken) public view returns (uint256){
        return _amount * _timeTaken * REWARDRATE
    }
}
