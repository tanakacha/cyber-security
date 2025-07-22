// SPDX-License-Identifier: MIT
pragma solidity ~0.4.24;

contract Secure_Vote_Chain {
    // 有権者、非有権者、管理者、候補者、政府
    enum ROLE {VOTER, NON_VOTER, ADMIN, CANDIDATE, GOV}

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
        string party;
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

    // 政府がMEMBERを登録(デバッグ用の関数)
    function register_member(address _addr, string _name, ROLE _role) only_GOV public {
        members[_addr] = MEMBER(_name, _role, true);
    }

    // 政府が有権者情報を登録
    function register_voter(address _addr, string _city) only_GOV public {
        voters[_addr] = VOTERS(members[_addr].name, _city, false);
    }

    // 有権者が立候補
    /*
        1. 立候補者のロールを変更
        2. 候補者の情報を登録(氏名は有権者情報から取得、立候補する市は自分で入力)
        3. 立候補の承認を政府に依頼
        4. 有権者情報の消去

    */
    function change_CANDIDATE(address _addr, string _city, string _party) only_account_owner(_addr) only_voter(_addr) public{
        members[_addr].role = ROLE.CANDIDATE;
        candidates[_addr] = CANDIDATES(voters[_addr].name, _city, _party);
        members[_addr].role_confirm = false;
        delete voters[_addr];
    }

    // 政府が立候補を承認
    function approval_CANDIDATE(address _addr) only_GOV public {
        members[_addr].role_confirm = true;
    }

    // MEMBERの確認(デバッグ用の関数)
    function view_member(address _addr) public view returns(string, ROLE, bool) {
        return (members[_addr].name, members[_addr].role, members[_addr].role_confirm);
    }

    // 有権者情報の確認(デバッグ用の関数)
    function view_voter(address _addr) public view returns(string, string, bool) {
        return (voters[_addr].name, voters[_addr].city, voters[_addr].vote_flag);
    }

    // 候補者情報の確認
    function view_candidate(address _addr) public view returns(string, string, string) {
        return (candidates[_addr].name, candidates[_addr].city, candidates[_addr].party);
    }

    // modifier
    // 自分のメンバーIDのみ実行
    modifier only_account_owner(address _addr) {
        require(msg.sender == _addr);
        _;
    }

    // 有権者のみ実行
    modifier only_voter(address _addr) {
        require(members[_addr].role == ROLE.VOTER);
        _;
    }
    
    // 政府のみ実行
    modifier only_GOV {
        require(msg.sender == GOV_addr);
        _;
    }
}