// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/access/AccessControl.sol";

contract dataAccessConsole is AccessControl {

    constructor() {
        // Grant the contract deployer the default admin role: it will be able
        // to grant and revoke any roles
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(keccak256("HOSPITAL_ADMIN"), msg.sender);
        _setRoleAdmin(keccak256("HOSPITAL_ADMIN"), keccak256("HOSPITAL"));
    }
    
    bytes32 public constant HOSPITAL_ADMIN = keccak256("HOSPITAL_ADMIN");
    bytes32 public constant HOSPITAL = keccak256("HOSPITAL"); //created hospital role
    bytes32 public constant APPROVER = keccak256("APPROVER"); //created approver role
    bytes32 public constant pDevelopment = keccak256("pDevelopment"); //created productdeveloper(consumer) role
    bytes32 public constant research = keccak256("research"); //created researcher role




    //mappings and arrays
    address[] patientsDB;
    address[] appliedConsumers;
    dataConsumer[] approvedConsumers;
    address[] pDevelopmentConsumers;
    address[] researchConsumers;
    
    
    
    
    struct Patient 
    {
        address Id;
        bool accessState;
    }

    

    struct dataConsumer {
        address c_Id; 
        bool ApprovalState;
        uint256 Purpose;
    }

    
    bool _default = false;

    mapping(address => Patient) public addressToPatient;
    mapping(address => dataConsumer) public addressToconsumer;
    mapping(string => bytes32) public purposeDB;
    // mapping(address => Hospital) public addressToHospital;

    //function to assign the hospital's role to an address
    function assignHospitalRole(address _address) public onlyRole(HOSPITAL_ADMIN){
        _setupRole(keccak256("HOSPITAL"), _address);
    }

    //function to assign the approver's role(by the admin)
    function assignApprover(address _address) public onlyRole(DEFAULT_ADMIN_ROLE){
        _setupRole(keccak256("APPROVER"), _address);
    }


    //consumer applies for approval. purpose = 1 for pDevelopment. 2 for research
    function applyAsConsumer(uint256 _purpose) public{
        addressToconsumer[msg.sender].c_Id = msg.sender;
        addressToconsumer[msg.sender].ApprovalState = _default;
        addressToconsumer[msg.sender].Purpose = _purpose;
        appliedConsumers.push(msg.sender);
    } 

    //consumer gets approved/rejected by the approver
    function consumerApproval(address _address, uint state) public onlyRole(APPROVER){
        if(state == 1){
            addressToconsumer[_address].ApprovalState = true;
        }
        if(addressToconsumer[_address].ApprovalState = true){
            approvedConsumers.push(addressToconsumer[_address]);
        }
    }

    //consumer gets assigned specific role
    function assignDataConsumer(address _address, bytes32 role) public onlyRole(HOSPITAL){
        require(addressToconsumer[_address].ApprovalState == true);
        _setupRole(role, _address);
        
    }

    
    

    function enterAsPatient() public{
        addressToPatient[msg.sender].Id = msg.sender;
        addressToPatient[msg.sender].accessState = _default;
        patientsDB.push(msg.sender);
    }


    function agreeToTC() public{
        addressToPatient[msg.sender].accessState = true;

    }
    function checkApprovedConsumers() public view returns( dataConsumer[] memory){
        return approvedConsumers;
    }

 
    function returnAppliedConsumers(uint i) public view returns(address) {
        return appliedConsumers[i];
    }

    function returnConsumerMappingBool(address add) public view returns(bool){
        return addressToconsumer[add].ApprovalState;
    }


    function returnPatientId(address add) public view returns(address){
        return addressToPatient[add].Id;
    }

    function returnPatientPermissionState(address add) public view returns(bool) {
        return addressToPatient[add].accessState;
    }
}