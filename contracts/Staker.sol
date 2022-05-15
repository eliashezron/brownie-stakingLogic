// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./RewardToken";

contract DeFiContract is RewardToken {
    //  staking/depositing of erc20 type tokens is allowed,
    //  issue of token rewards to the user,
    // first we have to myTokens into this contract so that it will be able to issue the out.
    //  unstaking/withdrawing of tokens
    address[] public stakers;
    uint256 public stakedAt;
    uint256 public Balance;
    mapping(address => uint256) public stakerBalance;
    mapping(address => bool) public authorizedUser;
    event stakerBalanceChanged(address indexed staker, uint256 newBalance);
    IERC20 public rewardToken;


    constructor(address _rewardTokenAddress) public {
        rewardToken = IERC20(_rewardTokenAddress);
    }

    function balanceOfToken(address _tokenAddress)
        public
        view
        returns (uint256)
    {
        return IERC20(_tokenAddress).balanceOf(msg.sender);
    }

    //  staking/depositing of erc20 type tokens is allowed,
    // require that the user has enough tokens to stake
    // require that the staking amount is not zero
    function deposit(address _token, uint256 _amount) public payable {
        require(_amount > 0, "Deposit an amount greater than 0");
        require(
            balanceOfToken(_token) >= _amount,
            "insufficient tokens available"
        );
        stakedAt = block.timestamp;
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        address token = _token;
        stakers.push(msg.sender);
        stakerBalance[msg.sender] = _amount;
        Balance = stakerBalance[msg.sender];
        emit stakerBalanceChanged(msg.sender, Balance);
    }

    modifier onlyStaker() {
        require(
            authorizedUser[msg.sender],
            "Only stakers users can claim tokens"
        );
        _;
    }

    // issue of token rewardTokens to the user
    function claimRewards() public onlyStaker {
        require(
            stakerBalance[msg.sender] > 0,
            "Stake some tokens to be able to claim reward"
        );
        uint256 timeStaked = block.timestamp - stakedAt;
        uint256 amountStaked = stakerBalance[msg.sender]
        uint256 reward = rewardTokensPS(amountStaked, timeStaked)
        Balance = stakerBalance[msg.sender] + reward;
        emit stakerBalanceChanged(msg.sender, Balance);
        stakedAt = block.timestamp;
    }

    // unstaking/withdrawing of tokens
    // require that the user has enough tokens to stake
    // require that the staking amount is not zero

    function withdraw(address _token, uint256 _amount) public payable {
        require(
            stakerBalance[msg.sender] > 0,
            "You have No tokens to withdraw"
        );
        require(
            balanceOfToken(_token) <= _amount,
            "insufficient Tokens availabe"
        );
        IERC20(_token).transfer(msg.sender, _amount);
        for (uint256 i = 0; i < stakers.length; i++) {
            if (stakers[i] == msg.sender) {
                stakers.pop();
                break;
            }
        }
        address token = _token;
        stakerBalance[msg.sender] = 0;
        Balance = stakerBalance[msg.sender];
        emit stakerBalanceChanged(msg.sender, Balance);
    }
}
