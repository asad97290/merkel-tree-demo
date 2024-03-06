// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

contract Encode {
    function encode(uint256 a, uint256 b) external pure returns (bytes memory) {
        return abi.encode(msg.sig, a, b);
    }

    function encodeCall(uint256 a, uint256 b)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeCall(Encode.encode, (a, b));
    }

    function encodeWithSignature(uint256 a, uint256 b)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSignature("encode(uint256,uint256)", a, b);
    }

    function encodeWithSelector(uint256 a, uint256 b)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSelector(Encode.encode.selector, a, b);
    }

    function encodePacked(uint8 a, uint256 b)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(uint8(6), a, b);
    }

    function getFuncId(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
    function getHex() external pure returns (bytes memory) {
        return hex"69";
    }
}

/**
0x
dc0aa2af00000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000002

0x
dc0aa2af
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000002

0x
dc0aa2af
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000005

0x
dc0aa2af
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000004


0x
06
01
0000000000000000000000000000000000000000000000000000000000000005
*/
