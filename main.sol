// SPDX-License-Identifier: MIT
pragma solidity ~0.4.24;

contract Secure_Vote_Chain {
    // 有権者、候補者
    enum ROLE {VOTER, CANDIDATE}

    // 選挙管理委員会
    address ADMIN_addr;

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
        bool vote_flag; // 投票済みかどうか、true: 投票済み, false: 未投票
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
    uint public vote_count = 0;

    // コンストラクタ
    constructor() public {
        ADMIN_addr = msg.sender;
    }

    /// 関数

    // 選挙管理委員会の関数
    // 選挙管理委員会が立候補を承認
    function approval_candidate(address _addr) only_ADMIN public {
        members[_addr].role_confirm = true;
    }

    // 選挙管理委員会が立候補を不承認
    function disapproval_candidate(address _addr) only_ADMIN public {
        members[_addr].role_confirm = false;
    }

    // 有権者情報を登録する関数(有権者以外の登録は許容しないシステム設計)
    function add_infor(address _addr, string _name, string _city) only_account_owner(_addr) public {
        members[_addr].name = _name;
        members[_addr].role = ROLE.VOTER;
        members[_addr].role_confirm = true;
        voters[_addr].name = _name;
        voters[_addr].city = _city;
        voters[_addr].vote_flag = false;
    }

    // 有権者が立候補
    /*
        1. 立候補者のロールを変更
        2. 候補者の情報を登録(氏名は有権者情報から取得、立候補する市は自分で入力)
        3. 立候補の承認を政府に依頼
        4. 有権者情報の消去

    */

    function become_candidate(address _addr, string _city, string _party) only_account_owner(_addr) only_voter(_addr) public{
        // メンバー情報の更新
        members[_addr].role = ROLE.CANDIDATE;
        members[_addr].role_confirm = false;

        // 候補者情報の登録
        candidates[_addr].name = voters[_addr].name;
        candidates[_addr].city = _city;
        candidates[_addr].party = _party;

        // 有権者情報の消去
        delete voters[_addr];
    }

    // 投票(投票記録の追加)
    function vote(address _addr, address _candidate_addr, string _city) only_approved_candidate(_candidate_addr)only_account_owner(_addr) only_voter(_addr) only_non_voter(_addr) only_voters_living_city(_addr, _candidate_addr, _city) public {
        votes[vote_count].voter_addr = _addr;
        votes[vote_count].candidate_addr = _candidate_addr;
        votes[vote_count].vote_time = 11;
        voters[_addr].vote_flag = true; // Use _addr instead of vote_count
        vote_count++;
    }

    // メンバー情報の確認(デバッグ用の関数)
    function view_member(address _addr) public view returns(string, ROLE, bool) {
        // memory: 明示的にメモリ上にコピーすることを宣言
        string memory _name = members[_addr].name;
        ROLE _role = members[_addr].role;
        bool _role_confirm = members[_addr].role_confirm;
        return (_name, _role, _role_confirm);
    }

    // 有権者情報の確認(デバッグ用の関数)
    function view_voter(address _addr) public view returns(string, string, bool) {
        string memory _name = voters[_addr].name;
        string memory _city = voters[_addr].city;
        bool _vote_flag = voters[_addr].vote_flag;
        return (_name, _city, _vote_flag);
    }

    // 候補者情報の確認(デバッグ用の関数)
    function view_candidate(address _addr) public view returns(string, string, string) {
        string memory _name = candidates[_addr].name;
        string memory _city = candidates[_addr].city;
        string memory _party = candidates[_addr].party;
        return (_name, _city, _party);
    }

    // 投票情報の確認(デバッグ用の関数)
    function view_votes(uint _vote_count) public view returns(address, address, uint) {
        address _voter_addr = votes[_vote_count].voter_addr;
        address _candidate_addr = votes[_vote_count].candidate_addr;
        uint _vote_time = votes[_vote_count].vote_time;
        return (_voter_addr, _candidate_addr, _vote_time);
    }

    /// modifier
    // 本人(addressが一致)のみ実行
    modifier only_account_owner(address _addr) {
        require(msg.sender == _addr);
        _;
    }

    // 有権者のみ実行
    modifier only_voter(address _addr) {
        require(members[_addr].role == ROLE.VOTER);
        _;
    }

    // 選挙管理委員のみ実行
    modifier only_ADMIN {
        require(msg.sender == ADMIN_addr);
        _;
    }

    // 該当する市に住んでいる人のみ
    modifier only_voters_living_city(address _addr, address _candidate_addr, string _city) {
        // ストレージ内の文字列とメモリ内の文字列を直接比較することができないため
        string memory voter_city = voters[_addr].city;
        string memory candidate_city = candidates[_candidate_addr].city;
        require((keccak256(bytes(voter_city)) == keccak256(bytes(_city))) && (keccak256(bytes(voter_city)) == keccak256(bytes(candidate_city))));
        _;
    }

    // 未投票者のみ
    modifier only_non_voter(address _addr) {
        require(voters[_addr].vote_flag == false);
        _;
    }

    // 候補者が承認されている場合のみ
    modifier only_approved_candidate(address _addr) {
        require(members[_addr].role_confirm == true);
        _;
    }

}