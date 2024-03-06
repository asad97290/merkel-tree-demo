// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/Token.sol";
contract ContractTest is Test {
    Token token;
    function setUp() public {
        token = new Token(
            "Token",
            "TS",
            50000000000000000000
        );
    }

    function testExample() public {
        assertTrue(token.decimals() == 18);
        assertEq(token.name(), "Token");
    }
    function testFailTransfer() public {
        token.transfer(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,2);
    }
    
    function testFuzzTransfer(address add,bool b) public {
        token.excludeFromTax(add,b);
    }

 

}
