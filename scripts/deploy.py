from brownie import accounts, dataAccessConsole
import time

def deploy_healthDataControl():
    data_control = dataAccessConsole.deploy({"from": accounts[0]})
    time.sleep(1)
    return data_control




def main():
    deploy_healthDataControl()