from scripts.deploy import deploy_healthDataControl
from brownie import accounts, dataAccessConsole
import time
import pytest


# Role Addresses:
# DEFAULT_ADMIN_ROLE - 0x0000000000000000000000000000000000000000000000000000000000000000 accounts[0]
# HOSPITAL_ADMIN - 0x47a8a9b8917c993d90f37744bb40dfb774c4593d1a1660ed38db000e33156502 accounts[0]
# HOSPITAL - 0x72d66193ff00a845b4aed5f27e02d9b558ef32be1495a41d00c5c5fb191a0763 accounts[1]
# APPROVER - 0x5ff1fb0ce9089603e6e193667ed17164e0360a6148f4a39fc194055588948a31 accounts[2]
# pDevelopment - 0x2ecc31ad8d2995e379a822ddc02a09243fb8ac7542b4057f34a97f725bc9776e
# research - 0x95f7801c97b17401c2c5a5b8fdb4f956cc377f647e35794f5b5da6aed60cd40d


@pytest.fixture
def consentManager():
    return dataAccessConsole.deploy({'from': accounts[0]})

def test_grantHospitalRole(consentManager):
    consentManager.assignHospitalRole(accounts[1], {"from": accounts[0]})
    assert consentManager.hasRole(0x72d66193ff00a845b4aed5f27e02d9b558ef32be1495a41d00c5c5fb191a0763, accounts[1])
    time.sleep(1)

def test_grantApproverRole(consentManager):
    consentManager.assignApprover(accounts[2], {"from": accounts[0]})
    assert consentManager.hasRole(0x5ff1fb0ce9089603e6e193667ed17164e0360a6148f4a39fc194055588948a31, accounts[2])
    time.sleep(1)

def test_applyAsConsumer(consentManager):
    consentManager.applyAsConsumer(1, {"from": accounts[3]})
    assert consentManager.returnAppliedConsumers(0) == accounts[3]
    time.sleep(1)

def test_consumerApproval(consentManager):
    consentManager.assignApprover(accounts[2], {"from": accounts[0]})
    consentManager.consumerApproval(accounts[3], 1, {'from': accounts[2]})
    assert consentManager.returnConsumerMappingBool(accounts[3])
    time.sleep(1)

def test_assignDataConsumer(consentManager):
    consentManager.assignHospitalRole(accounts[1], {"from": accounts[0]})
    consentManager.assignApprover(accounts[2], {"from": accounts[0]})
    consentManager.consumerApproval(accounts[3], 1, {'from': accounts[2]})
    consentManager.assignDataConsumer(accounts[3], 0x2ecc31ad8d2995e379a822ddc02a09243fb8ac7542b4057f34a97f725bc9776e, {'from': accounts[1]})
    assert consentManager.hasRole(0x2ecc31ad8d2995e379a822ddc02a09243fb8ac7542b4057f34a97f725bc9776e, accounts[3])

def test_enterAsPatient(consentManager):
    consentManager.enterAsPatient({'from': accounts[4]})
    assert consentManager.returnPatientId(accounts[4]) == accounts[4]

def test_agreeToTC(consentManager):
    consentManager.enterAsPatient({'from': accounts[4]})
    consentManager.agreeToTC({'from': accounts[4]})
    assert consentManager.returnPatientPermissionState(accounts[4])

def test_checkApprovedConsumers(consentManager):
    consentManager.applyAsConsumer(1, {"from": accounts[3]})
    consentManager.assignApprover(accounts[2], {"from": accounts[0]})
    consentManager.consumerApproval(accounts[3], 1, {'from': accounts[2]})
    assert consentManager.returnConsumerMappingBool(accounts[3])
    print(consentManager.checkApprovedConsumers())




