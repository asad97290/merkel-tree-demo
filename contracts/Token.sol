// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "./libraries/Errors.sol";

/**
 * @title WrappedToken
 * @dev A simple ERC20 token contract that allows minting and burning of tokens.
 *      This contract is used to represent assets on a blockchain in a wrapped form.
 */
contract Token is ERC20Capped, AccessControl {
      bytes32 private constant OWNER_ROLE = keccak256("OWNER_ROLE");
    address public ecoSystemWallet;
    address public marketingWallet;
    mapping(address => bool) public isExcludeFromTax;
    uint16 public marketingTax = 10; // 1%
    uint16 public ecosystemTax = 10; // 1%
    uint16 public burnTax = 5; // 0.5%
    bool public isTaxEnabled = true;

    /**
     * @dev Constructor function to initialize the WrappedToken contract.
     * @param name The name of the token.
     * @param symbol The symbol of the token.
     */
    constructor(
        string memory name,
        string memory symbol,
        uint _cap
    ) ERC20(name, symbol) ERC20Capped(_cap) {
        _grantRole(OWNER_ROLE, msg.sender);
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    }

    /**
     * @dev Function to mint new tokens and assign them to a specified address.
     * @param to The address to which the new tokens are minted.
     * @param amount The amount of tokens to be minted.
     */
    function mint(address to, uint amount) external onlyRole(OWNER_ROLE) {
        // Call the internal _mint function from ERC20 to create new tokens
        _mint(to, amount);
    }

    /**
     * @dev Function to burn existing tokens from a specified owner's balance.
     * @param owner The address from which the tokens are burned.
     * @param amount The amount of tokens to be burned.
     */
    function burn(address owner, uint amount) external {
        // Call the internal _burn function from ERC20 to destroy tokens
        _burn(owner, amount);
    }

    /**
     * @dev Function to set ecosystem address.
     * @param _ecoSystemWallet The address to ecosystem wallet.
     */
    function changeEcoSystemWallet(
        address _ecoSystemWallet
    ) external onlyRole(OWNER_ROLE) {
        if (_ecoSystemWallet == address(0)) {
            revert CommanErrors.ZeroAddress();
        }
        assembly {
            sstore(ecoSystemWallet.slot, _ecoSystemWallet)
        }
    }

    /**
     * @dev Function to set marketing address.
     * @param _marketing The address to  marketing wallet.
     */
    function changeMarketingWallet(
        address _marketing
    ) external onlyRole(OWNER_ROLE) {
        if (_marketing == address(0)) {
            revert CommanErrors.ZeroAddress();
        }
        assembly {
            sstore(marketingWallet.slot, _marketing)
        }
    }

    /**
     * @dev Function to update isExcludeFromTax mapping to exclude or include From Tax
     * @param _user The address to be exclude or include From Tax
     * @param _isExcludeFromTax true or false
     */
    function excludeFromTax(address _user, bool _isExcludeFromTax) external {
        assembly {
            let ptr := mload(0x40) //free memory pointer

            mstore(ptr, _user)
            mstore(add(ptr, 0x20), isExcludeFromTax.slot)
            sstore(keccak256(ptr, 0x40), _isExcludeFromTax)
        }
    }

    /**
     * @dev Function to toggle tax
     */
    function toggleTax() external {
        // 1 or 0  = 1
        // 1 and 0 = 0
        assembly {
            let a := sload(isTaxEnabled.slot)
            let b := shr(mul(isTaxEnabled.offset, 8), a)
            switch b
            case 0 {
                let c := or(
                    a,
                    0x0000000000000000000000000000000000000000000000000001000000000000
                )
                sstore(isTaxEnabled.slot, c)
            }
            case 1 {
                let c := and(
                    a,
                    0x0000000000000000000000000000000000000000000000000000ffffffffffff
                )
                sstore(isTaxEnabled.slot, c)
            }
        }
    }

    /**
     * @dev Function to set Marketing Tax
     * @param _marketingTax tax value
     */
    function setMarketingTax(
        uint16 _marketingTax
    ) external onlyRole(OWNER_ROLE) {
        assembly {
            let a := sload(marketingTax.slot)
            let b := shr(mul(marketingTax.offset, 8), _marketingTax)
            let c := and(
                a,
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000
            )
            sstore(marketingTax.slot, or(c, b))
        }
    }

    /**
     * @dev Function to set EcoSystem Tax
     * @param _ecosystemTax tax value
     */
    function setEcoSystemTax(
        uint16 _ecosystemTax
    ) external onlyRole(OWNER_ROLE) {
        assembly {
            let a := sload(ecosystemTax.slot)
            let b := shl(mul(ecosystemTax.offset, 8), _ecosystemTax)
            let c := and(
                a,
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000ffff
            )
            sstore(ecosystemTax.slot, or(c, b))
        }
    }

    /**
     * @dev Function to set burn Tax
     * @param _burnTax tax value
     */
    function setBurnTax(uint16 _burnTax) external onlyRole(OWNER_ROLE) {
        assembly {
            let a := sload(burnTax.slot)
            let b := shl(mul(burnTax.offset, 8), _burnTax)
            let c := and(
                a,
                0xffffffffffffffffffffffffffffffffffffffffffffffffffff0000ffffffff
            )
            sstore(burnTax.slot, or(c, b))
        }
    }
}
