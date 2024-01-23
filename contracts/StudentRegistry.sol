// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StudentRegistry {
    address public admin;

    struct Student {
        string name;
        string fatherName;
        string cnic;
        string serialNo;
        string registrationNo;
        string course;
        string session;
    }

    mapping(address => Student) public students;
    address[] public studentAddresses;

    event StudentAdded(
        address indexed studentAddress,
        string indexed name,
        string indexed course,
        string session,
        string message,
        bytes32 blockHash,
        uint256 blockNumber
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addStudent(
        string memory _name,
        string memory _fatherName,
        string memory _cnic,
        string memory _serialNo,
        string memory _registrationNo,
        string memory _course,
        string memory _session
    ) external onlyAdmin returns (string memory, bytes32, uint256) {
        require(!isStudentExists(_cnic, _serialNo, _registrationNo), "Student with these details already exists");

        address studentAddress = address(uint160(uint256(keccak256(abi.encodePacked(msg.sender, block.number, blockhash(block.number - 1))))));

        students[studentAddress] = Student({
            name: _name,
            fatherName: _fatherName,
            cnic: _cnic,
            serialNo: _serialNo,
            registrationNo: _registrationNo,
            course: _course,
            session: _session
        });

        studentAddresses.push(studentAddress);

        string memory successMessage = "Student data added successfully";
        bytes32 blockHash = blockhash(block.number - 1);

        emit StudentAdded(studentAddress, _name, _course, _session, successMessage, blockHash, block.number);

        return (successMessage, blockHash, block.number);
    }

    // function getStudentData(
    //     string memory _name,
    //     string memory _fatherName,
    //     string memory _cnic,
    //     string memory _serialNo,
    //     string memory _registrationNo,
    //     string memory _course,
    //     string memory _session
    // ) external view returns (string memory, bytes32, uint256, string memory) {
    //     for (uint256 i = 0; i < studentAddresses.length; i++) {
    //         Student storage existingStudent = students[studentAddresses[i]];

    //         if (
    //             keccak256(bytes(existingStudent.name)) == keccak256(bytes(_name)) &&
    //             keccak256(bytes(existingStudent.fatherName)) == keccak256(bytes(_fatherName)) &&
    //             keccak256(bytes(existingStudent.cnic)) == keccak256(bytes(_cnic)) &&
    //             keccak256(bytes(existingStudent.serialNo)) == keccak256(bytes(_serialNo)) &&
    //             keccak256(bytes(existingStudent.registrationNo)) == keccak256(bytes(_registrationNo)) &&
    //             keccak256(bytes(existingStudent.course)) == keccak256(bytes(_course)) &&
    //             keccak256(bytes(existingStudent.session)) == keccak256(bytes(_session))
    //         ) {
    //             // Return the matching student data and block details
    //             return (
    //                 string(abi.encodePacked(
    //                     "Name:", existingStudent.name,
    //                     ",FatherName: ", existingStudent.fatherName,
    //                     ",CNIC:", existingStudent.cnic,
    //                     ",SerialNo: ", existingStudent.serialNo,
    //                     ",RegistrationNo: ", existingStudent.registrationNo,
    //                     ",Course:", existingStudent.course,
    //                     ",Session:", existingStudent.session
    //                 )),
    //                 blockhash(block.number - 1),
    //                 block.number,
    //                 "Complete Block Details: " 
    //             );
    //         }
    //     }

    //     return ("THIS DEGREE IS NOT ISSUED BY AUST", bytes32(0), 0, "");
    // }


    function getStudentData(
    string memory _name,
    string memory _fatherName,
    string memory _cnic,
    string memory _serialNo,
    string memory _registrationNo,
    string memory _course,
    string memory _session
) external view returns (address, string memory, bytes32, uint256, string memory, bytes32) {
    for (uint256 i = 0; i < studentAddresses.length; i++) {
        address studentAddress = studentAddresses[i];
        Student storage existingStudent = students[studentAddress];

        if (
            keccak256(bytes(existingStudent.name)) == keccak256(bytes(_name)) &&
            keccak256(bytes(existingStudent.fatherName)) == keccak256(bytes(_fatherName)) &&
            keccak256(bytes(existingStudent.cnic)) == keccak256(bytes(_cnic)) &&
            keccak256(bytes(existingStudent.serialNo)) == keccak256(bytes(_serialNo)) &&
            keccak256(bytes(existingStudent.registrationNo)) == keccak256(bytes(_registrationNo)) &&
            keccak256(bytes(existingStudent.course)) == keccak256(bytes(_course)) &&
            keccak256(bytes(existingStudent.session)) == keccak256(bytes(_session))
        ) {
            // Return the matching student address, student data, block details, and block hash
            return (
                studentAddress,
                string(abi.encodePacked(
                    "Name:", existingStudent.name,
                    ",FatherName: ", existingStudent.fatherName,
                    ",CNIC:", existingStudent.cnic,
                    ",SerialNo: ", existingStudent.serialNo,
                    ",RegistrationNo: ", existingStudent.registrationNo,
                    ",Course:", existingStudent.course,
                    ",Session:", existingStudent.session
                )),
                blockhash(block.number - 1),
                block.number,
                "Complete Block Details: ",
                blockhash(block.number - 1)
            );
        }
    }

    return (address(0), "THIS DEGREE IS NOT ISSUED BY AUST", bytes32(0), 0, "", bytes32(0));
}







    function isStudentExists(string memory _cnic, string memory _serialNo, string memory _registrationNo) internal view returns (bool) {
        for (uint256 i = 0; i < studentAddresses.length; i++) {
            Student storage existingStudent = students[studentAddresses[i]];

            if (
                keccak256(bytes(existingStudent.cnic)) == keccak256(bytes(_cnic)) ||
                keccak256(bytes(existingStudent.serialNo)) == keccak256(bytes(_serialNo)) ||
                keccak256(bytes(existingStudent.registrationNo)) == keccak256(bytes(_registrationNo))
            ) {
                return true;
            }
        }

        return false;
    }

    function getAllStudentAddresses() external view returns (address[] memory) {
        return studentAddresses;
    }
}
