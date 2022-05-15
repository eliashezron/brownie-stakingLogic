from brownie import DeFiContract, accounts, network, Contract, RewardToken
from scripts.helpful_scripts import get_account, get_contract


def stakeAndClaim():
    account = get_account()
    print("deploying reward token")
    rewardToken = RewardToken.deploy({"from": account})
    print("reward token deployed at", rewardToken.address)
    defiContract = DeFiContract.deploy(rewardToken.address, {"from": account})
    print("defi contract deployed at", defiContract.address)
    return rewardToken, defiContract


def main():
    stakeAndClaim()
