// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
contract ClaimBonusToken is Ownable {
    bytes32 public merkleRoot;
    address private token;
    mapping(address => bool) private isClaimable;
    
    constructor(address _token,bytes32 _merkleRoot) Ownable(_msgSender()) {
        require(_token != address(0));
        token = _token;
        merkleRoot = _merkleRoot;
    }

    function claimBonus(
        uint256 _amount,
        bytes32[] calldata _merkleProof
    ) public payable {
        require(!isClaimable[_msgSender()],"already claimed");
        bytes32 leaf = keccak256(abi.encode(_msgSender(),_amount));
        console.logBytes32(leaf);
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Invalid markle proof"
        );

        isClaimable[_msgSender()] = true;
        IERC20(token).transfer(_msgSender(),_amount);
    }

    function updateMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }
    // only use in case of emergency 
    function withdrawTokens() external onlyOwner {
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
    }

}
