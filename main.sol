// SPDX-License-Identifier: MIT
pragma solidity ~0.4.24;

contract Secure_Vote_Chain {
    // 有権者、非有権者、管理者、候補者
    enum ROLE {VOTER, NON_VOTER, ADMIN, CONDIDATE}

    // 政府
    address GOV_addr;

    struct MEMBER {
        string name;
        ROLE role;
        bool role_confirm;
    }

    mapping (address => MEMBER) members;

    // 有権者情報
    struct VOTERS {
        string name;
        string city;
        bool vote_flag;
    }

    mapping (address => VOTERS) voters;

    // 候補者情報
    struct CANDIDATES {
        string name;
        string city;
    }

    mapping (address => CANDIDATES) candidates;

    // 投票記録
    struct VOTES {
        address voter_addr;
        address candidate_addr;
        uint vote_time;
    }

    mapping (uint => VOTES) votes;

    // コンストラクタ(GOV fuctions)
    constructor() public {
        GOV_addr = msg.sender;
    }

    // 関数


    // modifier

}