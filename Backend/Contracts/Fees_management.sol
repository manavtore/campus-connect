// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Management {
    struct Admin {
        address admin;
        string name;
    }

    struct Student {
        address student;
        string name;
        uint256 totalFees;
        uint256 feesPaid;
        uint256 feesDue;
    }

    Admin[] public admins;
    Student[] public students;

    mapping(address => bool) public isAdmin;

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "You are not an admin");
        _;
    }

    modifier onlyStudent(address _student) {
        require(msg.sender == _student, "You are not the authorized student");
        _;
    }

    function addAdmin(address _admin, string memory _name) public {
        admins.push(Admin(_admin, _name));
        isAdmin[_admin] = true;
    }

    function addStudent(address _student, string memory _name, uint256 _totalFees) onlyAdmin public {
        students.push(Student(_student, _name, _totalFees, 0, _totalFees));
    }

    function payFees(uint256 _feesPaid) onlyStudent(msg.sender) public payable {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].student == msg.sender) {
                require(students[i].feesDue >= _feesPaid, "Amount exceeds remaining fees");
                students[i].feesPaid += _feesPaid;
                students[i].feesDue -= _feesPaid;
            }
        }
    }

    function checkFees() public view returns (uint256 feesPaid, uint256 feesDue) {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].student == msg.sender) {
                feesPaid = students[i].feesPaid;
                feesDue = students[i].feesDue;
                return (feesPaid, feesDue);
            }
        }
    }
}
