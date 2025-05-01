// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract HearingSpeechRecord {
    address owner;

    struct Record {
        uint256 recordID;
        string patientName;
        string diagnosis;
        string treatment;
        // bool testPerformed;
        uint256 timestamp;
    }

    mapping(uint256 => Record[]) private patientRecords;

    mapping(address => bool) private authorizedProviders;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this Action");
        _;
    }

    modifier onlyAuthorizedProvider() {
        require(authorizedProviders[msg.sender], "Not an  Authorized Provider");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function authorizeProvider(address provider) public onlyOwner {
        authorizedProviders[provider] = true;
    }

    function createNewRecord(
        uint256 patientID,
        string memory patientName,
        string memory diagnosis,
        string memory treatment
    ) public onlyAuthorizedProvider {
        uint256 recordID = patientRecords[patientID].length + 1;
        patientRecords[patientID].push(
            Record(recordID, patientName, diagnosis, treatment, block.timestamp)
        );
    }

    function getPaitientRecords(
        uint256 patientID
    ) public view onlyAuthorizedProvider returns (Record[] memory) {
        return patientRecords[patientID];
    }
}
