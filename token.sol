// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
//import "@openzeppelin/contracts/math/SafeMath.sol";
contract token {
    
    using SafeMath for uint256;
    
    //variables and mappings 
    uint256 tokenprice;
    uint totalTok;
    mapping (address => uint) private balances;
    mapping (address => bool) public alreadyenrolled;
    mapping(address => mapping (address => uint256)) allowed;
    address public owner;
    uint public clientCount = 0;
    uint256 purchaseamount;
    uint256 transferamount;
    uint256 sellamount;
    uint256 totaltokenvalue;
    bytes32 tokenname;
    address[] adresses;
    
    //events 
    event Purchase(address buyer, uint amount);
    //event Transfer(address sender, address reciever, uint256 amount);
    event Sell(address seller, uint amount);
    event Price(uint256 price);
    event Enroll(address user);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    //functions 
    
    constructor() public {
        owner = msg.sender;
    }
     
    function enroll() public returns (uint)  { 
        if (alreadyenrolled[msg.sender] == true) { 
            return balances[msg.sender]; 
         } 
        else  { 
            clientCount++; 
            balances[msg.sender] = 20;//giving some balances to anyone who calls the  
            alreadyenrolled[msg.sender] = true; 
            adresses.push(msg.sender); 
            emit Enroll(msg.sender); 
            return balances[msg.sender]; 
         } 
    } 
     
    function buytoken(uint256 amount) public payable returns (bool)  { 
        //require(msg.value == purchaseamount); 
        require(amount <= balances[msg.sender]);
        balances[msg.sender] += amount; 
        emit Purchase(msg.sender, amount); 
        return true; 
    } 
     
    function transfer(address recipient, uint256 amount) public returns (bool)  { 
        balances[msg.sender] -= amount; 
        balances[recipient] += amount; 
        emit Transfer(msg.sender, recipient, amount); 
        return true; 
    } 
    /*What approve does is to allow an owner i.e. msg.sender to approve a delegate account
    possibly the marketplace itself to withdraw tokens from his account and to transfer them to other accounts*/
    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    /*This function returns the current approved number of tokens 
    by an owner to a specific delegate, as set in the approve function*/
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }
    
    /*The two require statements at function start are to verify that the transaction is legitimate,
    i.e. that the owner has enough tokens to transfer and that the delegate has approval
    for (at least) numTokens to withdraw*/
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] -=  numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] = balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
     
    function sellToken(uint256 amount) public payable returns (bool)  { 
        //sellamount = amount.mul(tokenprice); 
        //require(msg.value == sellamount); 
        //require(amount <= balances[msg.sender]);
        
        //we dont need any require statements for this
        balances[msg.sender] -= amount; 
        msg.sender.transfer(sellamount); 
        return true; 
    } 
     
    /*we dont need this function the following function so I'm not changing it, 
    you can comment it out because as I have chnaged the token value feature so it will 
    cause runtime error if you run it */ 
    function changePrice(uint256 price) public returns (bool)  { 
        require(msg.sender == owner); 
        uint i = 0; 
        uint totaltokens = 0; 
        for(i; i < clientCount; i++)  { 
        totaltokens += balances[adresses[i]]; 
         } 
        totaltokenvalue = price.mul(totaltokens); 
        require(address(this).balance >= totaltokenvalue); 
        tokenprice = price; 
        return true; 
         
    }
     
    function getBalance() public view returns (uint256)  { 
        return balances[msg.sender]; 
    } 
     
    function gettokenprice() public view returns (uint256)  { 
        return tokenprice; 
    } 
     
    function contractsBalance() public view returns (uint256)  { 
        return address(this).balance; 
     } 
     
} 