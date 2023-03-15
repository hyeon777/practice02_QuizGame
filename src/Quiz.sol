// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Quiz{
    struct Quiz_item {
      uint id;
      string question;
      string answer;
      uint min_bet;
      uint max_bet;
   }
    
    address public owner;
    mapping(address => uint256)[] public bets;
    mapping(uint => Quiz_item) public quiz_list;
    mapping(address => uint) public balances;
    uint public vault_balance;
    uint private quiz_num;

    constructor () {
        owner = msg.sender;

        Quiz_item memory q;
        q.id = 1;
        q.question = "1+1=?";
        q.answer = "2";
        q.min_bet = 1 ether;
        q.max_bet = 2 ether;
        addQuiz(q);
    }

    function addQuiz(Quiz_item memory q) public {
        require(msg.sender == owner);
        quiz_list[q.id] = q;
        quiz_num += 1;
    }

    function getAnswer(uint quizId) public view returns (string memory){
        require(msg.sender == owner);
        return quiz_list[quizId].answer;
    }

    function getQuiz(uint quizId) public view returns (Quiz_item memory) {
        Quiz_item memory quiz = quiz_list[quizId];
        quiz.answer = "";
        return quiz;
    }

    function getQuizNum() public view returns (uint){
        return quiz_num;
    }
    
    function betToPlay(uint quizId) public payable {
        Quiz_item memory q = quiz_list[quizId];
        uint256 betAmount = msg.value;

        require(betAmount >= q.min_bet);
        require(betAmount <= q.max_bet);
        bets.push();
        bets[quizId-1][msg.sender] += betAmount;
    }
    

    function solveQuiz(uint quizId, string memory ans) public returns (bool) {
        Quiz_item memory q = quiz_list[quizId];
        
        if(keccak256(bytes(q.answer)) == keccak256(bytes(ans))){
            balances[msg.sender] += bets[quizId-1][msg.sender] * 2;
            return true;
        }
        else{
            vault_balance += bets[quizId-1][msg.sender];
            bets[quizId-1][msg.sender] = 0;
            return false;
        }
    }

    function claim() public {
        uint amount = balances[msg.sender];
        payable(msg.sender).transfer(amount);
        balances[msg.sender] = 0;
    }
    receive() external payable {
    }

}