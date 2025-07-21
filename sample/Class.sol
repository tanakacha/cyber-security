// SPDX-License-Identifier: MIT
pragma solidity ~0.4.24;

contract Class_Member {

    struct MEMBER {
        string name;
        int score;
    }

    mapping (string => MEMBER) Member_Dic;

    function view_member (string _ID) view returns (string _name, int _score) {
        _name = Member_Dic[_ID].name;
        _score = Member_Dic[_ID].score;
    }

    function add_member (string _ID, string _name, int _score) public {
        Member_Dic[_ID].name = _name;
        Member_Dic[_ID].score = _score;
    }
}

// pragma solidity ~0.4.24;

// contract Class_Member {

//   // string : name

//   // int: score

//   // string : ID --> used as key for searching members

//   struct MEMBER {

//     string name;

//     int score;

//   }

//   mapping (string => MEMBER) Member_Dic;

//   function view_member (string _ID) view public returns (string _name, int _score) {

//     _name = Member_Dic[_ID].name;

//     _score = Member_Dic[_ID].score;

//   }

//   function add_member (string _ID, string _name, int _score) public {

//      Member_Dic[_ID].name = _name;

//      Member_Dic[_ID].score = _score;

//   }

// }