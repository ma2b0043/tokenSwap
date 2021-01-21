# tokenSwap
Smart Contract for Swapping TRC20/ERC20 token

### How to run
1. You should have 2-3 different account linked ropsten test networks, having 2-3 test ethers in them each.
2. Deploy the “token.sol” contract from 2 different accounts (going to call them A and B) and deploy “tokenSwap.sol” from another account(to be on the safe side).
3. After step 2, you should have “tokenSwap.sol” contract’s address in your metamax or remix. Open A’s instance of “token.sol” and approve 5 to “tokenSwap.sol” , using the approve function of “token.sol”. Similarly approve “tokenSwap.sol'' 7 token from B’s instance of “token.sol”. Use the following instructions:
	approve(address of tokenSwap contract, 5) for A
	approve(address of tokenSwap contract, 7) for B

4. Then open the instance of “tokenSwap.sol” and use swap function using the following input
	swap(5,7)
After this A will have 7 coins of B and B will have 5 coins of A.
