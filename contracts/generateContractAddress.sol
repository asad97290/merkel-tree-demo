//SPDX-License-Identifier: un-License
pragma solidity =0.8.24;
contract generateContractAddress{
    function add_gen() external pure{
        address add = address(
        uint160(
            uint256(
                keccak256(
                    // RECURSIVE-LENGTH PREFIX (RLP) SERIALIZATION
                    abi.encodePacked(
                        bytes1(0xd6), bytes1(0x94),
                        0x7F01C700fceDa557afd62D58eFa9D6e71001498f, // EOA
                        bytes1(0x04) // nonce
                    ))
                )
            )
        );
        assert(add == 0xd6946698AcDBb92D555Ec8CBB3Af56418f973cae);
    }
}