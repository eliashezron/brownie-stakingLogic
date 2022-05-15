from brownie import network, RewardToken
from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS, get_account
import pytest


def test_rewardToken():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("skipping test in non-local environment")
    # arrange
    account = get_account()
    rewardToken = RewardToken.deploy({"from": account})
    # act
    initial_supply = 100000000000000000000000
    # assert
    assert rewardToken.balanceOf(account.address) == initial_supply
