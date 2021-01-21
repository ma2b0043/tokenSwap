// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
import "token.sol";
contract tokenSwap {
    token public token1;
    address public owner1;
    uint public amount1;
    token public token2;
    address public owner2;
    uint public amount2;

    constructor(

        address _token1,
        address _owner1,
        uint _amount1,
        address _token2,
        address _owner2,
        uint _amount2
    ) {
        token1 = new token();
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = new token();
        owner2 = _owner2;
        amount2 = _amount2;
    }

    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        token tok,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = tok.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}