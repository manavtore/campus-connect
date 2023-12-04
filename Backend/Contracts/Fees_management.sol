// SPDX-License-Identifier: MIT

pragma solidity <=0.8.19;

contract Management
{

struct Admin{
    address admin;
    string name;
}



struct Student{
    address student;
    string name;
    uint256 totalfees_fees;
    uint256 feesPaid;
    uint256 feesDue;
}

Admin[] public admin;
Student[] public student;



modifier onlyAdmin(){
    bool isAdmin = false;
    for(uint256 i=0; i<admin.length; i++){
        if(admin[i].admin == msg.sender){
            isAdmin = true;
        }
    }
    require(isAdmin == true, "You are not an admin");
    _;
}



function addAdmin(address _admin, string memory _name) public{
    admin.push(Admin(_admin, _name));
}


function addStudent(address _student, string memory _name, uint256 _totalfees_fees) onlyAdmin public{
    student.push(Student(_student, _name, _totalfees_fees, 0, _totalfees_fees));
}


function payFees(address _student, uint256 _feesPaid) public payable{
    for(uint256 i=0; i<student.length; i++){
        if(student[i].student == _student){
            student[i].feesPaid += _feesPaid;
            student[i].feesDue -= _feesPaid;
        }
    }
}

  function checkFees(address _student) public view returns(uint256 _feespaid, uint256 _feesdue){
        for(uint256 i=0; i<student.length; i++){
            if(student[i].student == _student){
                return(student[i].feesPaid, student[i].feesDue);
            }
        
    }

    



}
}
